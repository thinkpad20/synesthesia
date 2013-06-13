module ImagesHelper

require 'midilib/sequence'
require 'midilib/consts'
require 'rmagick'
include MIDI

################# GET PITCH DATA FROM IMAGE

####helper method
def delta_to_note(delta)
	if delta < 4
		return (4.0/3.0) #triplet half
	elsif delta < 35
		return 1.0 #quarter
	elsif delta < 66
		return (2.0/3.0) #triplet quarter
	elsif delta < 97
		return 0.5 #eighth
	elsif delta < 128
		return (1.0/3.0) #triplet eighth
	elsif delta < 159
		return 0.25 #sixteenth
	elsif delta < 190
		return (0.5/3) #triplet sixteenth
	elsif  delta < 221
		return  0.125 #thirty-second
	elsif  delta < 252
		return  (0.25/3) #thirty-second triplet
	elsif  delta < 256
		return  0.0625 #sixty-fourth note
	end
end

def make_midi( path, output_name )

	puts "STARTINGGGGGGGGGGG"

	######get and prepare the image

	#read and resize
	img = Magick::Image.read(path)[0].resize_to_fill(200, 200)

	vals = {}

	img.each_pixel do |pixel, col, row|

	  # puts "Pixel at: #{col}x#{row}:
	  # \tR: #{pixel.red}, G: #{pixel.green}, B: #{pixel.blue}"

	if vals[col] == nil
		vals[col] = [ (pixel.red + pixel.green + pixel.blue)/3 ]
	else
	 	vals[col] << ( (pixel.red + pixel.green + pixel.blue)/3 )
	end

	end

	puts "JUST READDDDDDDDDDD"

	# puts "#{vals}"

	average_vals_per_column = []

	vals.each do |key, value|
		average_vals_per_column << (value.inject{|sum, el| sum + el}.to_f / vals.size)
	end

	#puts "avg #{average_vals_per_column}"

	puts "JUST AVERAGGGED"

	deltas = []
	average_vals_per_column.each_with_index do |val, index|
		if index == 0
			deltas[index] = val % 256
		else
			deltas[index] = ( (val - deltas[index-1]).abs ) % 256
		end
	end

	#puts "deltas #{deltas}"


	#####################

	seq = Sequence.new()

	# Create a first track for the sequence. This holds tempo events and stuff
	# like that.
	track = Track.new(seq)
	seq.tracks << track
	track.events << Tempo.new(Tempo.bpm_to_mpq(80))
	track.events << MetaEvent.new(META_SEQ_NAME, 'Sequence Name')

	# Create a track to hold the notes. Add it to the sequence.
	track = Track.new(seq)
	seq.tracks << track

	# Give the track a name and an instrument name (optional).
	track.name = 'My New Track'
	track.instrument = GM_PATCH_NAMES[0]

	# Add a volume controller event (optional).
	track.events << Controller.new(0, CC_VOLUME, 127)

	# Add events to the track: a major scale. Arguments for note on and note off
	# constructors are channel, note, velocity, and delta_time. Channel numbers
	# start at zero. We use the new Sequence#note_to_delta method to get the
	# delta time length of a single quarter note.
	track.events << ProgramChange.new(0, 1, 0)
	average_vals_per_column.each_with_index do |offset, index|
		#88 key piano has range from A0 (9) to C8 (96)
		offset = ((offset % 88) + 21).round

		#TODO: account for silences
		# velocity = 0
		# if offset == 8
		# 	velocity = 0
		# 	puts "zero velocity #{velocity}"
		# else
		# 	velocity = 127
		# end

	  	track.events << NoteOn.new(0, offset, 127, 0)
	  	note_length = seq.length_to_delta(delta_to_note(deltas[index]))
	  	track.events << NoteOff.new(0, offset, 127, note_length)
	end

	# Calling recalc_times is not necessary, because that only sets the events'
	# start times, which are not written out to the MIDI file. The delta times are
	# what get written out.

	# track.recalc_times

	puts "ABOUT TO WRITE MIDI"
	File.open("#{output_name}.mid", 'wb') { |file| seq.write(file) }
	puts "WROTE MIDI"
	final_output = get_final_output(path, output_name)
	system "fluidsynth -F #{output_name}.raw #{Rails.root.to_s}/lib/FluidR3_GM.sf2 #{output_name}.mid"
	puts "WROTE RAW"
	system "lame --preset standard #{output_name}.raw #{final_output}"
	puts "WROTE MP3"
	system "rm #{output_name}.mid #{output_name}.raw"
	puts "Successfully created file, final output = #{final_output}, (images helper) pwd:"
	system "pwd"
end

def get_final_output(path, output_name)
	return Rails.root.to_s + "/public/sound/#{output_name}.mp3"
end

def get_url(path, output_name)
	return "/public/sound/#{output_name}.mp3"
end

def sanitize_filename(filename)
  # Split the name when finding a period which is preceded by some
  # character, and is followed by some character other than a period,
  # if there is no following period that is followed by something
  # other than a period (yeah, confusing, I know)
  fn = filename.split /(?<=.)\.(?=[^.])(?!.*\.[^.])/m

  # We now have one or two parts (depending on whether we could find
  # a suitable period). For each of these parts, replace any unwanted
  # sequence of characters with an underscore
  fn.map! { |s| s.gsub /[^a-z0-9\-]+/i, '_' }

  # Finally, join the parts with a period and return the result
  return fn.join '.'
end

# make_midi("http://29a.ch/_shared/29a_theme/me.jpg", "blorbus")

end
