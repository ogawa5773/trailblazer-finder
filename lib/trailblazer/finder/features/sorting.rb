module Trailblazer
  class Finder
    module Features
      module Sorting
        def self.included(base)
          base.extend ClassMethods
          base.instance_eval do
            filter_by :sort do |entity_type, _|
              sort_it(entity_type, sort_attribute, sort_direction)
            end
          end
        end

        # Adapters will overwite this method
        def sort_it(entity_type, sort_attribute, sort_direction)
          case sort_direction
          when 'asc', 'ascending'
            entity_type.sort_by { |a| a[sort_attribute.to_sym] }
          when 'desc', 'descending'
            entity_type.sort_by { |a| a[sort_attribute.to_sym] }.reverse
          end
        end

        def sort?(attribute)
          attribute == sort || sort.to_s.start_with?("#{attribute} ")
        end

        def sort_attribute
          @sort_attribute ||= Utils::Extra.ensure_included sort.to_s.split(' ', 2).first, self.class.sort_attributes
        end

        def sort_direction
          @sort_direction ||= Utils::Extra.ensure_included sort.to_s.split(' ', 2).last, %w[desc asc]
        end

        def sort_direction_for(attribute)
          if sort_attribute == attribute.to_s
            reverted_sort_direction
          else
            'desc'
          end
        end

        def sort_params_for(attribute, options = {})
          options['sort'] = "#{attribute} #{sort_direction_for(attribute)}"
          params options
        end

        def reverted_sort_direction
          sort_direction == 'desc' ? 'asc' : 'desc'
        end

        module ClassMethods
          def sortable_by(*attributes)
            config[:sort_attributes]  = attributes.map(&:to_s)
            config[:defaults]['sort'] = "#{config[:sort_attributes].first} desc"
          end

          def sort_attributes
            config[:sort_attributes] ||= []
          end
        end
      end
    end
  end
end
