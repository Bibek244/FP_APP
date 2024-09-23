class CancelOrderMailer < ApplicationMailer
  def cancel_order_mailer(customer_id, delivery_order)
    @customer = Customer.find_by(id: customer_id)
    @delivery_order = delivery_order
    mail(
      to: @customer.email,
      subject: "Order Cancelled",
      from: "appfp43@gmail.com"
    ) do |format|
      format.html { render html: cancel_order_mail.html_safe }
    end
  end
  private
  def cancel_order_mail
    <<~HTML
      <h1>Hello #{@customer.email},</h1>
      <p>Your Order is cancelled.</p>
      <p>Order Group ID: #{@delivery_order.id}</p>
    HTML
  end
end
