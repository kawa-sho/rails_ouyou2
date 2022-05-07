class ContactMailer < ApplicationMailer
  def send_mail(user_name,mail_title,mail_content,group_users) #メソッドに対して引数を設定
    @user_name = user_name
    @mail_title = mail_title
    @mail_content = mail_content
    mail bcc: group_users.pluck(:email), subject: mail_title
  end
end
