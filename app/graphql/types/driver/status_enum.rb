module Types
  module Driver
    class StatusEnum < Types::BaseEnum
      value "AVAILABLE", " The driver is available and is ready to make delivery.", value: 0
      value "UNAVAILABLE", "The driver is unavailable at the moment.(On leave/Other reasons)", value: 1
      value "DEPLOYED", "The driver is currently making a delivery.", value: 2
    end
  end
end
