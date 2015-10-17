$ = window.$ = require 'jquery'

module.exports = app = {}

$ ->

	new p5 ( sketch ) ->

		# alias for p5 sketch
		s = sketch

		canvas    = null


		sound     = 
			background: null
			hits      : []


		fx = 
			reverb: null
			delay : null

		fft_cheap = null

		# frame counter
		counter = 0


		s.preload = =>


			sound.background = s.loadSound 'sounds/glitchme 4-Audio.wav'

			for i in [1..3]
				sound.hits.push s.loadSound "sounds/hitz/#{i}.wav"

			fft_cheap = new p5.FFT 0.9, 16

			canvas = s.createCanvas s.windowWidth, s.windowHeight

		s.setup = =>

			sound.background.rate 1
			sound.background.loop()

			$( 'body' ).append canvas.canvas


		s.mouseClicked = =>

			index = Math.floor( Math.random() * 3 )

			if not sound.hits[index] then return

			sound.hits[index].play()

		s.draw = =>

			spectrum = fft_cheap.analyze()


			s.noStroke()
			s.fill 50, 50, 50 # spectrum is green

			i = 0
			while i < spectrum.length

				# regular square bands
				# x = s.map( i, 0, spectrum.length, 0, s.width )
				h = -s.height + s.map(spectrum[i], 0, 255, s.height, 0) * 1
				# s.rect x, s.height, s.width / spectrum.length, h

				x = counter

				y = s.map( i, 0, spectrum.length, 0, s.height )

				color = 255 - ( 255 - spectrum[i] )

				s.fill color, color, color

				s.rect x, y, 1, s.height / spectrum.length

				
				i++

			if counter == s.width then counter = 0

			counter++

