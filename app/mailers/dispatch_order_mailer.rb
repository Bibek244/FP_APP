class DispatchOrderMailer < ApplicationMailer
  def dispatch_delivery_mailer(customer_id, delivery_order)
    @customer = Customer.find_by(id: customer_id)
    @delivery_order = delivery_order
    mail(
      to: @customer.email,
      subject: "Order on the way",
      from: "appfp43@gmail.com"
    ) do |format|
      format.html { render html: dispatch_order_mail.html_safe }
    end
  end
  private
  def dispatch_order_mail
    <<~HTML
      <h1>Hello #{@customer.email},</h1>
      <p>Your Order is dispatched form the warehouse.</p>
      <p>Order Group ID: #{@delivery_order.id}</p>
    HTML
  end
end
