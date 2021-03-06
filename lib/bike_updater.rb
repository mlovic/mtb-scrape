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
      # TODO dry this up
         #{@field.split('_').first}:  
      #p @field
      #if @field == :model_id
        #"#{@bike_id} - model:  #{Model.find(@old).name} -> #{Model.find(@new).name if @new}"
      #elsif @field == :brand_id
      # can't find Brand by id?
        #"#{@bike_id} - brand:  #{Brand.find(@old).name} -> #{Brand.find(@new).name if @new}"
      #else
        #"#{@bike_id} - #{@field}:  #{@old} -> #{@new}"
      #end
      "#{@bike_id} - #{@field}:  #{@old} -> #{@new}"
    end

    def report
      if @field == :model_id
        "#{@bike_id} - model:  #{Model.find_by(id: @old)&.name} -> #{Model.find_by(id: @new)&.name}"
      elsif @field == :brand_id
        "#{@bike_id} - brand:  #{Brand.find_by(id: @old)&.name} -> #{Brand.find_by(id: @new)&.name}"
      else
        "#{@bike_id} - #{@field}:  #{@old} -> #{@new}"
      end
    end

    def post_title
      Bike.find(@bike_id).post.title
    end

    private
    def old_model_name
      
    end
  end

  class Report
  end

#########
  
  def initialize
    @changes = []
    @num_bikes_changed = 0
  end

  GENERATED_ATTRS = %i(name brand_id price frame_only size model_id is_sold)
  # TODO probably not the place for this

  #diff
  def changes(attrs1, attrs2)
    old_attrs = attrs1.slice(*GENERATED_ATTRS)
    new_attrs = attrs2.slice(*GENERATED_ATTRS)

    return if old_attrs == new_attrs
    old_attrs.each do |k, v|
      next if new_attrs[k] == v
      @changes << Change.new(nil, k, v, new_attrs[k]) 
    end
  end

  def update_bike(bike, dry_run: false)
    parsed_attributes = PostParser.parse(bike.post)
    # TODO still creating models even when dry. deal with? 

    old_attrs = bike.attributes.symbolize_keys.slice(*GENERATED_ATTRS)
    new_attrs = parsed_attributes.slice(*GENERATED_ATTRS)

    return if old_attrs == new_attrs
    old_attrs.each do |k, v|
      next if new_attrs[k] == v
      puts "Changes for  #{bike.post.title}"
      @changes << Change.new(bike.id, k, v, new_attrs[k]) 
      #puts @changes.last.to_s
      puts @changes.last.report
      bike.update! @changes.last.field => @changes.last.new unless dry_run
    end
    @num_bikes_changed += 1
    @changes
  end

  def update_bikes(count: nil, id: nil, dry_run: false)
    # find each?
    # TODO fix this
    if id
      bikes = [Bike.find(id)]
    elsif count
      bikes = Bike.ordered_by_last_message.limit(count) # limit?
    elsif
      bikes = Bike.joins(:post).where.not('posts.deleted = 1').all # okay?
    end

    bikes.each do |bike|
      update_bike(bike, dry_run: dry_run)
    end

    report
  #CV
  # TODO what to do here
  rescue ActiveRecord::RecordInvalid => invalid
    p invalid
    p invalid.record
    puts invalid.record.errors
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
