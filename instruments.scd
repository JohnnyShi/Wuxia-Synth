/*
1. Pipa
2. Xiao
3. Drum
4. Wind
5. Leaf

"http://ecmc.rochester.edu/ecmc/docs/supercollider/scbook/Ch21_Interface_Investigations/ixi SC tutorial/ixi_SC_tutorial_10.html"
1. Karplus-Strong synthesis
2. Synthesis using a biquad filter
3. Waveguide flute
4. Other useful filters Klank, Resonz, Ringz, Decay, Formant
5. STK synthesis kit
6. Granular synthesis (GrainSin)
*/


// Part 1: Pipa or Zheng (Plucked)
// Karplus-Strong sound synthesis

FreqScope.new();

(

SynthDef(\ks_guitar, { arg note, pan, rand, delayTime, noiseType=1, low, lower, mid, high;
	var x, env;
	env = Env.new(#[1, 1, 0],#[2, 0.001]);
	// A simple exciter x, with some randomness.
	x = Decay.ar(Impulse.ar(0, 0, rand), 0.01+rand, WhiteNoise.ar); // decay
 	x = CombL.ar(x, 0.05, note.reciprocal, delayTime, EnvGen.ar(env, doneAction:2));  // decay

	u = BPF.ar(x, lower, 0.8);
	w = BPF.ar(x, low, 0.1);
	y = BPF.ar(x, mid, 0.08);
	z = BPF.ar(x, high, 0.01);

	x = Pan2.ar(u + w + y + z, pan);
	Out.ar(0, LeakDC.ar(x));
}).add;

)

(


a = Pdef(\kspattern,
		Pbind(\instrument, \ks_guitar, // using our sine synthdef
					\note, Pseq.new([60, 61, 63, 66], inf).midicps, // freq arg
					\dur, Pseq.new([0.25, 0.5, 0.25, 1], inf),  // dur arg
					\rand, Prand.new([0.2, 0.15, 0.15, 0.11], inf),  // dur arg
					\pan, 2.0.rand-1,
		\low, 600,
				\lower, 1800,
		\mid, 3600,
		\high, 4800,
					\delayTime, 0.01+1.0.rand;  // decay time

		)
).play;


)

// whitenoise demo
(
{
 var burstEnv, att = 0, dec = 0.001;
 var burst, delayTime, delayDecay = 0.5;
 var midiPitch = 69; // A 440
 delayTime = midiPitch.midicps.reciprocal;
 burstEnv = EnvGen.kr(Env.perc(att, dec), gate: Impulse.kr(1/delayDecay));
 burst = WhiteNoise.ar(burstEnv);
 CombL.ar(burst, delayTime, delayTime, delayDecay, add: burst);
}.play
)

// pinknoise demo
(
{
 var burstEnv, att = 0, dec = 0.001;
 var burst, delayTime, delayDecay = 0.5;
 var midiPitch = 69; // A 440
 delayTime = midiPitch.midicps.reciprocal;
 burstEnv = EnvGen.kr(Env.perc(att, dec), gate: Impulse.kr(1/delayDecay));
 burst = PinkNoise.ar(burstEnv);
 CombL.ar(burst, delayTime, delayTime, delayDecay, add: burst);
}.play
)


// Part 2: wind sound
// Rosonant low pass filter
SynthDef(\wind, {
	var windspd, snd;
	windspd = LFDNoise3.kr(LFNoise1.kr(1, 0.5, 0.5), 0.5, 0.5);
	snd = Pan2.ar(RLPF.ar(in:WhiteNoise.ar(), freq:windspd * 500 + 250, rq:LFNoise1.kr(1, 0.3, 0.5), mul:windspd * 0.5), LFDNoise3.kr(0.4, 0.5));
	Out.ar(0, snd);
}).add;

Synth(\wind);

// Part 3: Xiao sound
// Granular synthesis
(
SynthDef(\xiao, {arg freq = 440;
    var pan, env, freqdev, snd, winenv;
// a custom envelope
	winenv = Env([1, 2, 3, 1], [0.1, 0.1, 0.1]);
	z = Buffer.sendCollection(s, winenv.discretize, 1);
	env = EnvGen.kr(Env([2, 2, 1, 0], [0.5, 0.5, 0.1]), doneAction: 2);
	snd = GrainSin.ar(2, SinOsc.kr(), 1, freq, 0, z) * env;
    Out.ar(0, snd * 0.1);
    }).add;
)

Pbind(
	\instrument, \xiao,
	\freq, Prand([1, 1.1, 1.2, 1.3, 1, 4, 1.5] * 440, inf),
	\dur, Prand([1, 2, 3], inf) * 0.5,
).play;

// Part 4: Drum sound
// waveguide
(
{ var excitation = EnvGen.kr(Env.perc,
                            MouseButton.kr(0, 1, 0),
                             timeScale: 0.1, doneAction: 0
                            ) * WhiteNoise.ar(0.4);
  var tension = MouseX.kr(0.01, 0.1);
  var loss = MouseY.kr(0.999999, 0.999, 1);
  MembraneCircle.ar(excitation, tension, loss);
}.play;
)

SynthDef(\drum, { arg tension, loss;
	var excitation = EnvGen.kr(Env.perc, timeScale: 0.1, doneAction: 0) * WhiteNoise.ar(0.4);
	tension = SinOsc.kr(5, 0, 0.2);
	// tension = SinOsc.kr(0.01, 0.1);
	loss = 0.9999 + SinOsc.kr(5, 0, 0.0001);
	// loss = SinOsc.kr(0.999999, 0.999, 1);
    MembraneCircle.ar(excitation, tension, loss);
}).add;

Pbind(
	\instrument, \drum,
).play;




// Part 5: Leaf sound

// Part 6: Water sound

// Part 7: Sword sound

// Part 8: Wooden Knocker

(
{
	var son, son2;
	son = Klank.ar(`[     // Klank: A bank of fixed requency resonators
		[521,  800, 1034],  // freqs
		[0.7, 0.5, 0.25],// amps
		[0.3, 0.3, 0.3]   // ring times
		]
	, Impulse.ar(1));
	son2 = CombL.ar(son, 0.2, 0.2, 0.2, 1, 0);
	Out.ar(0, Pan2.ar(son2 * 0.2));
}.play;
)

// Part 9: Temple Bell
(
{
	var son, son2;
	son = Klank.ar(`[     // Klank: A bank of fixed requency resonators
		[151,  250, 334],  // freqs
		[0.9, 0.6, 0.15],// amps
		[6.0, 2.6, 1.4]   // ring times
		]
	, Impulse.ar(1));
	son2 = CombL.ar(son, 0.2, 0.2, 0.2, 1, 0);
	Out.ar(0, Pan2.ar(son * 0.2));
}.play;
)

// Part 10: Another Plucked Zheng
(
SynthDef(\help_dwgplucked, { |out=0, freq=440, amp=0.5, gate=1, c3=20, pan=0|
    var env = Env.new([0,1, 1, 0],[0.001,0.006, 0.0005],[5,-5, -8]);
    var inp = amp * LFClipNoise.ar(2000) * EnvGen.ar(env,gate);
    var son = DWGPlucked2.ar(freq, amp, gate,0.1,1,c3,inp);
    DetectSilence.ar(son, 0.001, doneAction:2);
    Out.ar(out, Pan2.ar(son * 0.1, pan));
}).add;
)

//Use it.
(
a = Scale.new(
    #[0, 1, 3, 5, 7, 8, 10],
    12,
    Tuning.new([0, 0.75, 2, 3.5, 4, 5, 6, 7, 8, 9, 10, 11]),
    "Custom"
);

Pbind(
    \instrument, \help_dwgplucked,
    \scale ,a,
    \delta , Pseq([1,0.5,0.5,0.5,0.5,0.5,0.5,1,0.5,0.5,1,1]*0.25,inf), // Use delta to control the time until next event
    \dur , 2, // dur should be the same
    \degree, Pseq([1,8,8,8,8,8,8,-6,Prand([9,10,11],1),1,7,8]-8, inf),
    \amp , Pwhite(0.2,0.8),
    \c3 , Pseq([Pseq([1400],24),Pseq([300],24)],inf),
    \pan , Pwhite(-1,1),
).play;
)

