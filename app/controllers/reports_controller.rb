require "telegram"
class ReportsController < ApplicationController
	def create
		if params[:notification_type] != "MessageSent"
			params[:external_contact_id] = User.last.external_id if !User.last.nil? && params[:external_contact_id].blank?
			user = User.find_by external_id: params[:external_contact_id]
			message = nil
			if user.nil?
				user = User.create external_id: params[:external_contact_id], name: params[:name]
				if is_command?(params)
					run_commands(params)
				else
					msg = "Hello\nWelcome to #WhatIsARoad. Help us map the potholes you see in 3 easy steps.\n\nSend /report or click on the 'Report' button below to submit a new report."
					Telegram.send_keyboard(user, msg, [['Report']])
				end
			else
				if is_command?(params)
					message = run_commands(params)
				else
					report = user.reports.incomplete.last
					if report.nil?
						report = start_report(user)
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
										message = progress_step(step, report).prompt_text
									end
								else
									if !params[:notification_type] == "ImageReceived"
										message = "Please send the location of the pothole."
									elsif params[:notification_type] == "MessageReceived"
										coordinates = Geocoder.coordinates(params[:text])
										if !coordinates.blank?
											report.update(latitude: coordinates[0], longitude: coordinates[1], address: params[:text])
											if !step.next_step.nil?
												message = progress_step(step, report).prompt_text
											end
										else
											message = "Please send a valid location of the pothole."
										end
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
										message = progress_step(step, report).prompt_text
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
				end
				Telegram.send_message(user, message) if !message.nil?
			end
		end
		render json: {success: true}
	end

	def progress_step step, report
		if !step.next_step.nil?
			report.progress_step
			current_step = report.current_step
		end
		current_step
	end

	def is_command? params
		params[:notification_type] == "MessageReceived" && !params[:text].blank? && params[:text].start_with?("/")
	end

	def run_commands params
		user = User.find_by external_id: params[:external_contact_id]
		if !user.nil?
			report = user.reports.incomplete.last
			case params[:text]
			when '/help'
				message = "To report a pothole, click on the 'Report' button or send /report and answer the questions that follow. \n- You can either share the location of the pothole or send the name of the road. \n- You can send any number of photos of the pothole any time. \n- You can restart the report at any point by sending /restart. \n- To find out more about this service, send /about."
			when '/restart'
				if report.nil?
					msg = "You don't have an incomplete report to restart. Send /report or click on the 'Report' button below to submit a new report."
					Telegram.send_keyboard(user, msg, [['Report']])
				else
					reset_report(report)
					report = start_report(user)
					message = "Your most recent report has been reset.\n\n#{report.current_step.prompt_text}"
				end
			when '/about'
				message = "#WhatIsARoad is a service that gives you the ability to report potholes. These potholes are then mapped and made available to the public and all stakeholders concerned."
			when '/report'
				report = user.reports.incomplete.last
				if report.nil?
					report = start_report(user)
					message = report.current_step.prompt_text
				else
					step = report.current_step
					message = "You were in the middle of submitting a report. Please complete your report. Send /restart to start over. If you want to complete your report, please answer the question below:\n\n#{step.prompt_text}"
				end
			when '/start'
				if report.nil?
					msg = "Hello\nWelcome to #WhatIsARoad. Help us map the potholes you see in 3 easy steps.\n\nSend /report or click on the 'Report' button below to submit a new report."
					Telegram.send_keyboard(user, msg, [['Report']])
				else
					step = report.current_step
					message = "Please finish your report.\n\n#{step.prompt_text}"
				end
			else
				message = "You sent #{params[:text]}. Please send /help to find out how to use this bot."
			end
		end
		message
	end

	def start_report user
		report = Report.create! user: user
		report.progresses.create! step: Step.first
		report
	end

	def reset_report report
		report.photos.destroy_all
		report.progresses.destroy_all
		report.delete
	end
end
