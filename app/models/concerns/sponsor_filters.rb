module SponsorFilters
  extend ActiveSupport::Concern

  COMP_OPERATORS = {
    'LIKE' => [
      :city,
      :country,
      :gender
    ],
    '=' => [
      :agent_id,
      :branch_id,
      :organization_id,
      :request_fulfilled,
      :sponsor_type_id,
      :status_id
    ],
    '>' => [
      :created_at_from,
      :start_date_from,
      :updated_at_from
    ],
    '<' => [
      :created_at_until,
      :start_date_until,
      :updated_at_until
    ]
  }

  module ClassMethods
    def add_filter(query, current_filter, all_filters)
      filter_name = current_filter[0]
      filter_value = current_filter[1]

      ignored = %i(active_sponsorship_count_value name_value)

      if ignored.include?(filter_name)
        query
      elsif filter_name == :active_sponsorship_count_option
        add_active_sponsorship_count_filter(query, all_filters)
      elsif filter_name == :name_option
        add_name_filter(query, all_filters)
      else
        comp_operator = lookup_operator(filter_name)
        add_where(query, filter_name, comp_operator, filter_value)
      end
    end

    private

    def lookup_operator(field)
      COMP_OPERATORS.select { |_, v| v.include? field }.keys.first
    end

    def add_active_sponsorship_count_filter(query, filters)
      option = filters[:active_sponsorship_count_option]
      value = filters[:active_sponsorship_count_value]
      comp_operator = {
        'equals' => '=',
        'greater_than' => '>',
        'less_than' => '<'
      }[option]

      add_where(query, :active_sponsorship_count, comp_operator, value)
    end

    def add_name_filter(query, filters)
      option = filters[:name_option]
      value = filters[:name_value]

      where_args = {
        'contains' => ['ILIKE', "%#{value}%"],
        'equals' => ['ILIKE', value],
        'starts_with' => ['~*', "^#{value}"],
        'ends_with' => ['~*', "#{value}$"]
      }[option]

      add_where(query, :name, where_args[0], where_args[1])
    end

    def add_where(query, field, comp_operator, value)
      return query unless comp_operator && value

      query.where("#{field} #{comp_operator} ?", value)
    end
  end
end
