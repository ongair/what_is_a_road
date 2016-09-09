require 'telegrammer'

class Telegram
	def self.bot
		Telegrammer::Bot.new(Rails.application.secrets.bot_token)
	end

	def self.update params
		Telegrammer::DataTypes::Update.new(
		      update_id: params[:update_id],
		      message: params[:message]
		    )
	end

	# def self.send_message user, text
	# 	HTTParty.post("https://ongair.im/api/v1/base/send", body: {token: Rails.application.secrets.ongair_token, external_id: user.external_id, text: text, thread: true})
	# end

	def self.send_keyboard user, text="", options=[]
		reply_markup = Telegrammer::DataTypes::ReplyKeyboardMarkup.new(
		  keyboard: options,
		  resize_keyboard: true,
		  one_time_keyboard: false
		)
		bot.send_message(chat_id: user.external_id, text: text, reply_markup: reply_markup)
	end

	def self.hide_keyboard user, text=""
		reply_markup = Telegrammer::DataTypes::ReplyKeyboardHide.new(
		  hide_keyboard: true
		)
		bot.send_message(chat_id: user.external_id, text: text, reply_markup: reply_markup)
	end

	def self.send_message user, text, options=[], keyboard=false
		if keyboard
			reply_markup = Telegrammer::DataTypes::ReplyKeyboardMarkup.new(
			  keyboard: options,
			  resize_keyboard: false
			)
		else
			reply_markup = Telegrammer::DataTypes::ReplyKeyboardHide.new(
			  hide_keyboard: true
			)
		end
		begin
			bot.send_message(chat_id: user.external_id, text: text, reply_markup: reply_markup)
		rescue Telegrammer::Errors::BadRequestError => e

		end
	end

	def self.send_image user, image_url, file_name="", caption="", content_type=""
		ongair.send_image(user.external_id, image_url, file_name, caption, content_type, true)
	end
end
