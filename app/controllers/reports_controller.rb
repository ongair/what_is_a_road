require "telegram"
class ReportsController < ApplicationController
	def create
		if params[:notification_type] != "MessageSent"
			params[:external_contact_id] = User.last.external_id if !User.last.nil? && params[:external_contact_id].blank?
			user = User.find_by external_id: params[:external_contact_id]
			message = nil
			if user.nil?
				user = User.create external_id: params[:external_contact_id], name: params[:name]
				Telegram.send_keyboard(user, "Click on the 'Report' button below to report a pothole", [['Report']])
			else
				report = user.reports.incomplete.last
				if report.nil?
					report = Report.create! user: user
					report.progresses.create! step: Step.first
					message = report.current_step.prompt_text
				else
					step = report.current_step
					if !step.nil?
						if params[:notification_type] == "ImageReceived"
							report.photos.find_or_create_by! file_url: params[:image]
						end
						case step.step_type
						when "Location"
							if params[:notification_type] == "LocationReceived"
								report.update(latitude: params[:latitude], longitude: params[:longitude])
								if !step.next_step.nil?
									report.progress_step
									message = report.current_step.prompt_text
								end
							else
								if !params[:notification_type] == "ImageReceived"
									message = "Please send the location of the pothole."
								else
									render json: {success: true}
									return
								end
							end
						when "Text"
							if params[:notification_type] == "MessageReceived"
								if step.name == "Road"
									report.update(road: Road.find_or_create_by!(name: params[:text]))
								elsif step.name == "Comment"
									report.update(comment: params[:text])	
								end
								if !step.next_step.nil?
									report.progress_step
									message = report.current_step.prompt_text
								end
							else
								if !params[:notification_type] == "ImageReceived"
									message = "Please send a #{step.name}."
								else
									render json: {success: true}
									return
								end
							end
						when "Photo"
							if step.name == "Photo"
								if params[:notification_type] == "ImageReceived"
									# report.photos.create! file_url: params[:image]
									if !step.next_step.nil?
										report.progress_step
										message = report.current_step.prompt_text
									end
								else
									message = "Please send an image."
								end
							end
						else
							message = "We don't support that format #{step.step_type}." unless params[:notification_type] == "ImageReceived"
						end
						if step.next_step.nil?
							report.update(complete: true)
							if message.nil? && report.complete
								Telegram.send_keyboard(user, "Thank you for your report. If you want to report another pothole, just click on the 'Report' button again.", [['Report']])
							end
						end
					end
				end
				puts ">>>>>> #{message}"
				Telegram.send_message(user, message) if !message.nil?
			end
		end
		render json: {success: true}
	end
end
