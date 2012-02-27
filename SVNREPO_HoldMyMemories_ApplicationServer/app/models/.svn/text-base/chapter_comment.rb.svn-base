class ChapterComment < ActiveRecord::Base
  
  def count_by_sql(sql)
        sql = sanitize_conditions(sql)
        connection.select_value(sql, "#{name} Count").to_i
      end
  
   
  
end
