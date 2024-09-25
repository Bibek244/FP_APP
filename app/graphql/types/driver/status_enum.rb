module Types
  module Driver
    class StatusEnum < Types::BaseEnum
      value "AVAILABLE", "Driver is available", value: "AVAILABLE"
      value "UNAVAILABLE", "Driver is unavailable", value: "UNAVAILABLE"
      value "DEPLOYED", "Driver is deployed", value: "DEPLOYED"
    end
  end
end
