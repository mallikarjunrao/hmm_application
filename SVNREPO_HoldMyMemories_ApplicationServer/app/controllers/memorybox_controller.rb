class MemoryboxController < ApplicationController

  def folders_files_list
    folders=MemoryboxFolder.find(:all,:order=>"parent_id ASC")
     folder_info=[]
    for folder in folders
      file_info=[]
      files=MemoryboxFile.find(:all,:conditions=>"folder_id=#{folder.id}")
     for file in files
       f={:id=>file.id,:folder_id=>file.folder_id,:file_name=>file.file_name,:file_path=>"#{file.file_url}/#{file.file_directory}/#{file.file_name}"}
       file_info.push(f)
     end
     folder_data={:id=>folder.id,:folder_name=>folder.folder_name,:user_id=>folder.user_id,:parent_id=>folder.parent_id,:files=>file_info}
     folder_info.push(folder_data)
    end
    logger.info(folder_info.inspect)
    render :text=>folder_info.to_json
  end


end
