class MovieTest
	@@user = Array.new
        @@movie = Array.new
        @@rating = Array.new
        @@predict_rating = Array.new

	def user(index,value)
		@@user[index]=value
	end

	def movie(index,value)
		@@movie[index]=value
	end

	def rating(index,value)
		@@rating[index]=value
	end
	
	def predict_rating(index,value)
		@@predict_rating[index]=value
	end

	def mean
		i=0
		sum=0
		while i<@@user.length
			sum = sum + (@@rating[i]-@@predict_rating[i])
			i=i+1
		end
		return sum
	end
	
	def stddev
		i=0
		sum=0.0
		while i<@@user.length
			sum=sum+(@@rating[i]-@@predict_rating[i])*(@@rating[i]-@@predict_rating[i])
		end
		return sum/@@user.length
	end

	def rms
		return Math.sqrt(stddev)
	end
	
	def to_a
	end
end

class MovieData 
	def initialize(filepath)
		user_id = Array.new(100000)
		movie_id = Array.new(100000)
		rating = Array.new(100000)
		timestamp = Array.new(100000)
		i=0	
		File.open(filepath+"/u.data","r") do |file|
			while line = file.gets
				word_cut =line.split('')
				user_id[i] = word_cut[0].to_i
				movie_id[i] = word_cut[1].to_i
				rating[i] = word_cut[2].to_i/1.0
				timestamp[i] = word_cut[3].to_i
				i=i+1
			end
		end
	end
	@@z= MovieTest.new()
	@@base_user_id = Array.new(80000)
        @@base_movie_id = Array.new(80000)
        @@base_rating = Array.new(80000)
      	@@base_timestamp = Array.new(80000)

	@@test_user_id = Array.new(20000)
        @@test_movie_id = Array.new(20000)
        @@test_rating = Array.new(20000)
        @@test_timestamp = Array.new(20000)

	@@predict_rating = Array.new
	
	def initialize(filepath, filename)		
  		i = 0
                File.open(filepath+"/"+filename+".base","r") do |file|
			while line = file.gets
				word_cut =line.split(' ')
				@@base_user_id[i] = word_cut[0].to_i
                        	@@base_movie_id[i] = word_cut[1].to_i
                        	@@base_rating[i] = word_cut[2].to_i/1.0
                        	@@base_timestamp[i] = word_cut[3].to_i

				i=i+1
			end
		end

		i = 0
  		File.open(filepath+"/"+filename+".test","r") do |file|
			while line = file.gets
				word_cut = line.split(' ')
				@@test_user_id[i] = word_cut[0].to_i
				@@test_movie_id[i] = word_cut[1].to_i
				@@test_rating[i] = word_cut[2].to_i/1.0
				@@test_timestamp[i] = word_cut[3].to_i
				i=i+1
			end
		end
	end
	
	def rating(u,m)
		i=0
		while i < 80000
			if (@@base_user_id[i]==u)&&(@@base_movie_id[i]==m)
				return @@base_rating[i]
			end	
			i=i+1
		end	
		rating 0	
	end

	def predict(u,m)
		num=0.0
		sum=0.0
		@@base_movie_id.each_with_index do |value, index|
			if value == m
				sum = sum + @@base_rating[index]
				num=num+1.0
			end
		end
		return sum/num
	end

	def movies(u)
		c=Array.new
		@@base_user_id.each_with_index do |value, index|
			if value == u
				c<< @@base_movie_id[index]
			end
		end
		return c		
	end

	def viewers(m)
		c=Array.new
		@@base_movie_id.each_with_index do |value, index|
			if value==m
				c<< @@base_user_id[index]
			end
		end
		return c
	end

	def run_test(k)
		i=0
		if k== nil
			m= 20000
		else 
			m=k
		end

		while i<m
			@@predict_rating<<predict(1,@@test_movie_id[i])
			@@z.user(i,@@test_user_id)
			@@z.movie(i,@@test_movie_id)
			@@z.rating(i,@@test_rating)
			@@z.predict_rating(i,@@predict_rating)	
			i=i+1
		end
		return @@z
	end
end
t = MovieTest.new()
z = MovieData.new("ml-100k","u1")
t = z.run_test(20)
