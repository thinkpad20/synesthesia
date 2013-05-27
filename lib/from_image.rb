# adapted from midilib 'from_scratch' example

require 'midilib/sequence'
require 'midilib/consts'
require 'rmagick'
include MIDI

def make_midi(path)
	##### get and prepare the image

	img = Magick::Image::read(path)[0]

	img = img.resize_to_fill(100,100)

	vals = []

	img.each_pixel do |pixel, col, row|
		vals = vals << ((pixel.red + pixel.green + pixel.blue) / 3)
	end

	###########

	seq = Sequence.new()

	# Create a first track for the sequence. This holds tempo events and stuff
	# like that.
	track = Track.new(seq)
	seq.tracks << track
	track.events << Tempo.new(Tempo.bpm_to_mpq(400))
	track.events << MetaEvent.new(META_SEQ_NAME, 'Sequence Name')

	num_tracks = 5
	limit = vals.length / num_tracks
	offset = 0

	freq = vals.inject(Hash.new(0)) { |h,v| h[v] += 1; h }
	most_common = vals.sort_by { |v| freq[v] }.last

	range = 3

	num_tracks.times do
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
		quarter_note_length = seq.note_to_delta('eighth')
		count = 0
		while count < limit do
			if vals[count + offset].to_i % range != most_common
				note = vals[count + offset].to_i % range
			  	track.events << NoteOn.new(0, 64 + note, 127, 0)
			  	track.events << NoteOff.new(0, 64 + note, 127, quarter_note_length)
			end
		  offset = offset + 1
		  count = count + 1
		  if (count % 100) == 0
		  	range = range + 1
		  end
		end
	end

	File.open('../tmp/midi/new.mid', 'wb') { |file| seq.write(file) }
	puts "Successfully created file"
end

make_midi("http://brookeramey.files.wordpress.com/2011/05/beach-ball-544_610.gif")