module Filterable
  extend ActiveSupport::Concern

  module ClassMethods
    def filtered(filters={})
      query = self.where(nil)
      filters.reduce(query) do |memo, filter|
        self.add_filter(memo, filter, filters)
      end
    end

    private

    def unknown_filter(query, _value)
      query
    end
  end
end
