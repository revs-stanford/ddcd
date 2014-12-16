def tag_path(tag)
  "/tags/#{tag}"
end

def link_to_tag(tag)
  link_to tag, tag_path(tag)
end


def visualization_data_path(fname)
  "/visualizations/data/#{fname}"
end
