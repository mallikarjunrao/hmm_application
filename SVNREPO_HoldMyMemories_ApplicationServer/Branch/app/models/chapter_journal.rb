class ChapterJournal < ActiveRecord::Base
  def self.find_by_sql_with_limit(sql, offset, limit)
            sql = sanitize_sql(sql)
            add_limit!(sql, {:limit => limit, :offset => offset})
            find_by_sql(sql)
        end

        def self.count_by_sql_wrapping_select_query(sql)
            sql = sanitize_sql(sql)
            count_by_sql("select count(*) from (#{sql}) as my_table")
        end
        
 #       module ActiveRecord
#    class Base
#        def self.find_by_sql_with_limit(sql, offset, limit)
#            sql = sanitize_sql(sql)
#            add_limit!(sql, {:limit => limit, :offset => offset})
#            find_by_sql(sql)
#        end
#
#        def self.count_by_sql_wrapping_select_query(sql)
#            sql = sanitize_sql(sql)
#            count_by_sql("select count(*) from (#{sql})")
#        end
#   end
#end
#  
#  def paginate_by_sql(model, sql, per_page, options={})
#       if options[:count]
#           if options[:count].is_a? Integer
#               total = options[:count]
#           else
#               total = model.count_by_sql(options[:count])
#           end
#       else
#           total = model.count_by_sql_wrapping_select_query(sql)
#       end
#   end 

end
