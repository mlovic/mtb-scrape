class BikeUpdater
  # come up with method that tracks changes. At least number of records changed
  #Change = Struct.new(:bike_id, :field, :old_value, :new_value)
  
  class Change
    attr_accessor :bike_id, :field, :old, :new

    def initialize(bike_id, field, old_value, new_value)
      @bike_id, @field, @old, @new = bike_id, field, old_value, new_value
      @logger = Logger.new($stdout)
    end

    def new_attr?
      @old.nil?
    end

    def lost_attr?
      @new.nil?
    end

    def to_s
      "#{@bike_id} - #{@field}:  #{@old} -> #{@new}"
    end

    def post_title
      Bike.find(@bike_id).post.title
    end
  end

  class Report
  end

#########
  
  def initialize
    @changes = []
    @num_bikes_changed = 0
  end

  GENERATED_ATTRS = %i(name brand_id price frame_only size model_id)

  def update_bikes(dry_run: false)
    # find each?
    Bike.all.each do |bike|
      parsed_attributes = PostParser.parse(bike.post)

      old_attrs = bike.attributes.symbolize_keys.slice(*GENERATED_ATTRS)
      new_attrs = parsed_attributes.slice(*GENERATED_ATTRS)

      next if old_attrs == new_attrs
      old_attrs.each do |k, v|
        next if new_attrs[k] == v
        @changes << Change.new(bike.id, k, v, new_attrs[k]) 
        puts @changes.last.to_s
        bike.update! @changes.last.field => @changes.last.new unless dry_run
      end
      @num_bikes_changed += 1
    end

    report
  end

  private
    def report
      @changes.each do |c|
        puts c.to_s + c.post_title
      end
      GENERATED_ATTRS.each do |a|
        rel_changes = @changes.select { |c| c.field == a }
        new_changes = rel_changes.select { |c| c.new_attr? }
        old_changes = rel_changes.select { |c| c.lost_attr? }

        new_changes.each { |c| puts c }
        old_changes.each { |c| puts c }
        puts "#{new_changes.count} new attributes found of #{a}"
        puts "#{old_changes.count} attributes attributes lost"
        puts "=============="
        puts ''
        #@logger.info works
      end
      puts "#{@num_bikes_changed} bikes changed"
      puts "#{@changes.count} total changes"
        # if nil
        # maybe also for each field state how many found, how many lost

    end
      
    #def equal_attributes?(bike, post)

    #end
end
