class QuoteMailer < ActionMailer::Base
  default from: "contact@stockbot.io"

  def quote_email(quote)
  	@quote = quote
    mail(to: @quote.email, subject: 'Your Stockbot Quote')
  end
end
