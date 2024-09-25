class OrderMailMailer < ApplicationMailer
  def create_order_mailer(customer_id, order_group)
    @customer = Customer.find_by(id: customer_id)
    @order_group = order_group
    mail(
      to: @customer.email,
      subject: "Order Group Created",
      from: "appfp43@gmail.com"
    ) do |format|
      format.html { render html: order_created_mail.html_safe }
    end
  end
  private
  def order_created_mail
    <<~HTML
      <h1>Hello #{@customer.email},</h1>
      <p>Your Order Has Been Received. You will be notified as soon as order is dispatched soon</p>
      <p>Order Group ID: #{@order_group.id}</p>
    HTML
  end
end
