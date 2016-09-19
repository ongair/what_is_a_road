require 'telegrammer'

class Telegram
	def self.bot
		Telegrammer::Bot.new(ENV['BOT_TOKEN'])
	end

	def self.update params
		Telegrammer::DataTypes::Update.new(
		      update_id: params[:update_id],
		      message: params[:message]
		    )
	end

	def self.send_message user, text, options=""
		HTTParty.post("https://ongair.im/api/v1/base/send", body: {token: ENV['ONGAIR_TOKEN'], external_id: user.external_id, text: text, thread: true, reply_options: options}, debug_out: $stdout)
	end

	def self.request_location user, text
		# https://api.telegram.org/bot270331460:AAEXchRw0bR2l9h1YJRbEHLl_H225iKRkKw/sendMessage?text=Hello&chat_id=80474561&reply_markup=
		reply_markup = {
			keyboard: [[{text: "Report", request_location: true}]],
			resize_keyboard: true,
			one_time_keyboard: false
		}
		HTTParty.post("https://api.telegram.org/bot#{ENV['BOT_TOKEN']}/sendMessage", body: {chat_id: user.external_id, text: text, reply_markup: reply_markup})
	end

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

	# def self.send_message user, text, options=[], keyboard=false
	# 	if keyboard
	# 		reply_markup = Telegrammer::DataTypes::ReplyKeyboardMarkup.new(
	# 		  keyboard: options,
	# 		  resize_keyboard: false
	# 		)
	# 	else
	# 		reply_markup = Telegrammer::DataTypes::ReplyKeyboardHide.new(
	# 		  hide_keyboard: true
	# 		)
	# 	end
	# 	begin
	# 		bot.send_message(chat_id: user.external_id, text: text, reply_markup: reply_markup)
	# 	rescue Telegrammer::Errors::BadRequestError => e

	# 	end
	# end

	def self.send_image user, image_url, file_name="", caption="", content_type=""
		ongair.send_image(user.external_id, image_url, file_name, caption, content_type, true)
	end
end
