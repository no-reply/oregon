require 'bagit'

module Hybag
  module Baggable

    def write_bag(path = Dir[Rails.root.join("tmp/bags")])
      bag_path = File.join(path, self.pid)
      BagIt::Bag.new(bag_path)
      #TODO: Writing to bag files is naive; reads file out and writes it.
      #      Possibly there is a better way to do this.

      # add the content datastreams
      bag_contents.each do |label, ds|
        bag.add_file(label + mime_extension(ds)) { |f|
          f.puts ds.content
        }
      end
      bag.manifest!

      # add non-fedora tag files
      bag_tags.each do |label, ds|
        bag.add_tag_file(label + mime_extension(ds)) { |f|
          f.puts ds.content
        }
      end

      # add fedora tag files
      bag_fedora_tags.each do |label, ds|
        bag.add_tag_file('fedora/' + label + mime_extension(ds)) { |f|
          f.puts ds.content
        }
      end

      return bag
    end



    private

    #TODO: allow selection of specific content datastreams to bag
    #      to ignore thumbnails and other derivitives, for example.

    # return all content files for bag
    def bag_contents
      self.datastreams.reject { |label, ds| bag_tags.include?(label) or bag_fedora_tags.include?(label) }
    end

    # return all non-fedora tag files
    def bag_tags
      self.datastreams.select { |label, ds| ds.kind_of?(ActiveFedora::MetadataDatastream) or ds.kind_of?(ActiveFedora::NokogiriDatastream) or ds.kind_of?(ActiveFedora::RDFDatastream)  }
    end

    # return fedora tag files
    def bag_fedora_tags
      self.datastreams.select { |label, ds| ds.is_a?(ActiveFedora::RelsExtDatastream) or ds.dsid == "DC"}
    end

    def mime_extension(ds)
      if ds.kind_of?(ActiveFedora::NtriplesRDFDatastream)
        ext = 'nt'
      else
        ext = MIME::Types[ds.mimeType].first.extensions[0]
      end
      return '.' + ext
    end

  end
end

