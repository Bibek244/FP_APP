class CompletedOrderMailer < ApplicationMailer
  def completed_delivery_mailer(customer_id, delivery_order)
    @customer = Customer.find_by(id: customer_id)
    @delivery_order = delivery_order
    mail(
      to: @customer.email,
      subject: "Order delivery Confirmaion mail",
      from: "appfp43@gmail.com"
    ) do |format|
      format.html { render html: complete_order_mail.html_safe }
    end
  end
  private
  def complete_order_mail
    <<~HTML
      <h1>Hello #{@customer.email},</h1>
      <p>Your Order is delivered successfully. If Otherwise reply to this mail as soon as possible</p>
      <p>Order Group ID: #{@delivery_order.id}</p>
    HTML
  end
end
