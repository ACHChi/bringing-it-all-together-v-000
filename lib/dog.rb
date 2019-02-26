class Dog
 
attr_accessor :name, :breed
attr_reader :id
 
  def initialize(id=nil, name, breed)
    @id = id
    @name = name
    @breed = breed
  end
 
  def save
    if self.id 
      self.update
    else
      sql = <<-SQL
        INSERT INTO songs (name, breed) 
        VALUES (?, ?)
      SQL
 
      DB[:conn].execute(sql, self.name, self.breed)
      @id = DB[:conn].execute("SELECT last_insert_rowid() FROM songs")[0][0]
    end
  end
 
  def self.create(name:, breed:)
    song = Song.new(name, breed)
    song.save
    song
  end
 
  def self.find_by_id(id)
    sql = "SELECT * FROM songs WHERE id = ?"
    result = DB[:conn].execute(sql, id)[0]
    Song.new(result[0], result[1], result[2])
  end
 
  def update
    sql = "UPDATE songs SET name = ?, breed = ? WHERE id = ?"
    DB[:conn].execute(sql, self.name, self.breed, self.id)
  end
end