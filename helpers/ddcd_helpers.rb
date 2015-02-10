
def get_dataset_object(o)
  if o.respond_to?(:data)
    slug = File.basename(current_page.path, '.html')
  else
    slug = o
  end

  all_datasets.find{|d| d.slug == slug}
end


def all_visualizations
  config[:all_visualizations]
end

def all_datasets
  config[:all_datasets]
end

