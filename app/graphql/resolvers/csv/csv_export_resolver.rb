class Resolvers::Csv::CsvExportResolver < Resolvers::BaseResolver
  type String, null: false

  argument :id, ID, required: true

  def resolve(id:)
    customer = Customer.find_by(id: id)
    unless customer
      raise GraphQL::ExecutionError, "Customer not found."
    end

    file_name = "export_#{Time.now.to_i}.csv"
    csv_data = ::CsvServices::CsvGeneratorServices.new(customer.id).generate_csv
    file_path = Rails.root.join("public", "csv_exports", file_name)
    FileUtils.mkdir_p(Rails.root.join("public", "csv_exports"))
    File.write(file_path, csv_data)

    "/csv_exports/#{file_name}"
  end
end
