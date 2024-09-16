module Types
  module Driver
    class StatusEnum < Types::BaseEnum
      value "AVAILABLE", " The driver is available and is ready to make delivery."
      value "UNAVAILABLE", "The driver is unavailable at the moment.(On leave/Other reasons)"
      value "DEPLOYED", "The driver is currently making a delivery."
    end
  end
end
