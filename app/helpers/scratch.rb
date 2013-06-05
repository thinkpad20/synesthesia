scale = { "major" => [0, 2, 4, 5, 7, 9, 11, 12],
			"minor" => [0, 2, 3, 5, 7, 8, 10, 12]
		}
starting_pitch_midi_val = { "a" => 21, "a#" =>22, "b"=>23, "b#"=>24, "c"=>25, "c#"=>26,
							"d"=>, "e" =>27, "f"=>28, "f#"=>29, "g"=>30, "g#"=>31
							}

def output_midi_values_in_key_signature( scale_val, starting_pitch )
	starting_pitch_val = starting_pitch_midi_val[starting_pitch]

	final_values = []
	for oct in 0..5 do
		for scale[scale_val].each do |step|

			final_values << starting_pitch_val + (step + 12*oct)

		end

	end

	final_values

end
