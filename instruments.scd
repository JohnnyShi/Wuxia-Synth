/*

Part 1: Wind sound
Part 2: Water (rain drop) sound
Part 3: Leaf sound
Part 4: Sword sound
Part 5: Xiao sound
Part 6: Voicetest


Part 7: Pipa
Part 8: Zheng
Part 9: Wooden Knocker
Part 10: Temple Bell
(Part 11: Chinese Drum)


Reference:
http://ecmc.rochester.edu/ecmc/docs/supercollider/scbook/Ch21_Interface_Investigations/ixi SC tutorial/ixi_SC_tutorial_10.html
1. Karplus-Strong synthesis
2. Synthesis using a biquad filter
3. Waveguide flute
4. Other useful filters Klank, Resonz, Ringz, Decay, Formant
5. STK synthesis kit
6. Granular synthesis (GrainSin)
*/


s.boot;
FreqScope.new();

// Part 1: Wind sound
// Rosonant low pass filter, WhiteNoise for input, freq and mul is proprotional to the speed of wind
(
SynthDef(\Wind, { |amp=0.3|
	var windspd, snd;
	windspd = LFDNoise3.kr(LFNoise1.kr(1, 0.5, 0.5), 0.5, 0.5);
	snd = Pan2.ar(RLPF.ar(in:WhiteNoise.ar(), freq:windspd * 500 + 250, rq:LFNoise1.kr(1, 0.3, 0.5), mul:windspd * 0.5), LFDNoise3.kr(0.1, 0.1));
	Out.ar(0, snd * amp);
}).add;
)
// Large amplitude for strong wind
s.record("/Users/xinzhang/Desktop/Sound/Strong Wind.wav");
s.stopRecording;
(
Synth(\Wind, [
	\amp, 1
]);
)
// Small amplitude for mid wind
s.record("/Users/xinzhang/Desktop/Sound/Mild Wind.wav");
s.stopRecording;
(
Synth(\Wind, [
	\amp, 0.05
]);
)


// Part 2: Water (rain drop)
// Use SinOsc for the sound, use percussive envelop, high-pass filter to remove any lowpitched artifacts, add reverb to make it more real
s.record("/Users/xinzhang/Desktop/Sound/Rain Drop.wav");
s.stopRecording;
(
SynthDef(\RainDrop, { |out=0, t_trig=1, attack=0.01, decay=0.08, pitchcurvelen=0.1, freq=600, doneAction=0, amp=0.1|
 var pitch, snd;
 amp   = amp * EnvGen.ar(Env.perc(attack, decay).delay(0.003), t_trig, doneAction: doneAction);
 pitch = freq * EnvGen.ar(Env.new([0,0,1],[0,1]).exprange(1, 2.718), t_trig, timeScale: pitchcurvelen);
 snd = SinOsc.ar(pitch);
 snd = HPF.ar(snd, 500) * amp * 10;
 snd = FreeVerb.ar(snd);
 Out.ar(out, snd);
}).add;
)
x = Synth(\RainDrop);


// Part 3: Leaf sound
// apply a high pass filter on WhiteNoise
s.record("/Users/xinzhang/Desktop/Sound/Leaf.wav");
s.stopRecording;
(
SynthDef(\Leaf, { |dur|
	var snd = HPF.ar(WhiteNoise.ar, 1000) * LFNoise2.ar(1, 1).squared.squared * Line.ar(1, 1, dur: dur, doneAction:2);
	snd = Pan2.ar(snd);
	Out.ar(0, snd);
}).add;
)
(
Synth(\Leaf, [
	\dur, 100
]);
)


// Part 4: Sword sound
// use MembraneHexagon UGen, which is Waveguide mesh physical models of drum membranes, use WhiteNoise for the excitation signal, applies BPF and RHPF and decay to make it more like sword sound. adjust the tension level and attacktime/releaseTime/timeScale of envelop to make different sword sounds.
(
SynthDef(\Sword, {|attackTime = 0.01, releaseTime = 1, timeScale = 0.6, tension = 0.1|
	var excitation = EnvGen.kr(Env.perc(attackTime: attackTime, releaseTime: releaseTime, level: 1, curve: -4), timeScale: timeScale, doneAction: 2) * WhiteNoise.ar(0.5);
 var loss = 0.999999999;
 var snd = MembraneHexagon.ar(excitation, tension, loss);
 // snd = HPF.ar(snd, 2000);
 snd = BPF.ar(snd, 3000, 0.2 );
 snd = RHPF.ar(snd, 3000, 0.1);
 snd = Decay.ar(snd, 0.9);
 Out.ar(0, snd);

}).add;
)

s.record("/Users/xinzhang/Desktop/Sound/Sword_1.wav");
s.stopRecording;
(
Synth(\Sword, [
	\tension, 0.1,
	\attackTime, 0.01,
	\releaseTime, 1,
	\timeScale, 0.6
]);
)

s.record("/Users/xinzhang/Desktop/Sound/Sword_2.wav");
s.stopRecording;
(
Synth(\Sword, [
	\tension, 0.11,
	\attackTime, 0.01,
	\releaseTime, 1,
	\timeScale, 0.6
]);
)

s.record("/Users/xinzhang/Desktop/Sound/Sword_3.wav");
s.stopRecording;
(
Synth(\Sword, [
	\tension, 0.1,
	\attackTime, 0.01,
	\releaseTime, 1,
	\timeScale, 1
]);
)

s.record("/Users/xinzhang/Desktop/Sound/Sword_4.wav");
s.stopRecording;
(
Synth(\Sword, [
	\tension, 0.12,
	\attackTime, 0.01,
	\releaseTime, 1,
	\timeScale, 0.6
]);
)

s.record("/Users/xinzhang/Desktop/Sound/Sword_5.wav");
s.stopRecording;
(
Synth(\Sword, [
	\tension, 0.13,
	\attackTime, 0.01,
	\releaseTime, 1,
	\timeScale, 1
]);
)


// Part 5: Xiao sound
// use StkInst, which is  a wrapping of Synthesis toolkit of physical model instruments
s.record("/Users/xinzhang/Desktop/Sound/Xiao.wav");
s.stopRecording;
// ar (freq: 440, jetDelay: 49, noisegain: 0.15, jetRatio: 0.32, mul: 1, add: 0)
(
SynthDef(\helpStkflute,{arg out=0,freq=220,gate=1,amp=1;
    var sig,env,noise;
    env = EnvGen.kr(Env.adsr(2, 1.5, 1, 1 ),gate,doneAction:2);
    sig = StkInst.ar(Stk.at("Flute"),freq, gate, amp, 0.5,[440, 49, 95, 0.32, 1, 0])*env;
	sig = LPF.ar(sig,3000);
	// noise = WhiteNoise.ar(0.2);
	    Out.ar(out, sig);
}).add;
)
(
Pbind(
    \instrument, \helpStkflute,
	\sustain, Pseq([0.1,0.1,0.1,3,0.1,1,0.1,4,0.1,0.1,0.1,0.1,3.0,0.1,1,0.1,2] + 0.15),
	    \dur , Pseq([0.1,0.1,0.1,3,0.1,1,0.1,4,0.1,0.1,0.1,0.1,3.0,0.1,1,0.1,2]),
	    \degree, Pseq([11,12,8,9,8,9,8,9,4,5,1,3,2,1,2,1,2],inf),
    \amp , Pseq([0.5,0.6,0.7,0.8,0.6,0.7,0.5,0.6],inf),
).play;
)


// Part 6: Voicetest
// read sound file into buffer, and apply RLPF and adjust playrate
s.record("/Users/xinzhang/Desktop/Sound/Read.wav");
s.stopRecording;
(
Buffer.read(s, "/Users/xinzhang/Desktop/voicetest.wav", action: { |buffer|
	{Pan2.ar(RLPF.ar(PlayBuf.ar(1, buffer, 0.8, loop:100, doneAction:2), 1000, 0.5))}.play;
});
)





// Part 7: Pipa
s.record("/Users/xinzhang/Desktop/Sound/Ambush.wav");
s.stopRecording;
(
SynthDef(\Pipa, { arg note, pan, rand, delayTime, noiseType=1, low, lower, mid, high;
	var x, env;
	var strum = BPF.ar(WhiteNoise.ar(0.94), 2000, 0.01) * Env.perc(0.01, 0.001).kr;
	env = Env.new(#[1, 1, 0],#[2, 0.001]);
	// A simple exciter x, with some randomness.
	x = Decay.ar(Impulse.ar(0, 0, rand), 0.01+rand, WhiteNoise.ar); // decay
 	x = CombL.ar(x, 0.05, note.reciprocal, delayTime, EnvGen.ar(env, doneAction:2));  // decay

	u = BPF.ar(x, lower, 0.1);
	w = BPF.ar(x, low, 0.6);
	y = BPF.ar(x, mid, 0.05);
	z = BPF.ar(x, high, 0.01);

	x = Pan2.ar(u + w + y + z + (strum * 3), pan);
	Out.ar(0, LeakDC.ar(x));
}).add;
)
(// The Ambush
// Section 1
~notes_1 = Array.fill(80, {[43,62,62,74]});
~highest_string_dur_1 = [1.72,1.02,0.62,0.42,0.32,0.27,0.22,0.17,0.12,0.07];
~dur_1_temp = Array.fill(10, {|index|[0.07,0.07,0.07,0.07,~highest_string_dur_1[index]]}) ++ Array.fill(6, {Array.fill(5, {0.05})});
~dur_1 = Array.new(80);
~dur_1_temp.size.do{|index|
	~dur_1 = ~dur_1 ++ ~dur_1_temp[index];
};
// Section 2
~notes_2 = Array.fill(40,{[43,48,64,76]});
~notes_2_2 = Array.fill(5, {[63,63,64,76]});
~notes_2_3 = Array.fill(35, {[64,64,64,76]});
~notes_2 = ~notes_2 ++ ~notes2_2 ++ ~notes2_3;
~dur_2 = Array.fill(80,{0.05});
~notes_3 = Array.fill(4, {[43,48,50,72]}) ++ Array.fill(26,{72});
~dur_3 = Array.fill(4,{0.05});
~notes_4 = Array.fill(4, {[43,48,50,74]}) ++ Array.fill(26, {74});
~dur_4 = Array.fill(30,{0.05});
~notes_5 = Array.fill(5, {[71]});
~dur_5 = Array.fill(5, {0.05});

~notes = ~notes_1 ++ ~notes_2 ++ ~notes_3 ++ ~notes_4 ++ ~notes_5;
~dur= ~dur_1 ++ ~dur_2 ++ ~dur_3 ++ ~dur_4 ++ ~dur_5;

(
a = Pdef(\pipapattern,
		Pbind(\instrument, \Pipa, // using our sine synthdef
		\note, Pseq.new(~notes).midicps, // freq arg
		\dur, Pseq.new(~dur),  // dur arg
		\sustain, 2,
		\rand, Pseq.new([0.51, 0.51, 0.51, 0.51, 0.81], inf),  // dur arg
		\pan, [0,1],
		\strum, Pseq([0.01, 0.01, 0.01, 0.01, 0.03], inf),
		\low, 600,
		\lower, 1200,
		\mid, 3600,
		\high, 4800,
		\delayTime, 0.91;  // decay time
		)
).play;)
)


// Part 8: Zheng
// Karplus-Strong sound synthesis
// use UGen DWGPlucked
s.record("/Users/xinzhang/Desktop/Sound/Zheng.wav");
s.stopRecording;
(
SynthDef(\zheng1, { |out=0, freq=440, amp=0.5, gate=1, c3=20, pan=0|
    var env = Env.new([0,1, 1, 0],[0.001,0.006, 0.0005],[5,-5, -8]);
    var inp = amp * LFClipNoise.ar(2000) * EnvGen.ar(env,gate);
    var son = DWGPlucked2.ar(freq, amp, gate,0.1,1,c3,inp);
    DetectSilence.ar(son, 0.001, doneAction:2);
    Out.ar(out, Pan2.ar(son * 0.1, pan));
}).add;
)

// version 2 - with extra plectrum noise
(
SynthDef(\zheng2, { |out=0, freq=440, amp=0.5, gate=1, c3=20, pan=0, slct=1|
    var env = Env.new([0,1, 1, 0],[0.001,0.006, 0.0005],[5,-5, -8]);
    var inp = amp * LFClipNoise.ar(2000) * EnvGen.ar(env,gate);
	var strum = BPF.ar(WhiteNoise.ar(0.94), 2500, 0.01) * Env.perc(0.01, 0.001).kr;
	var son = DWGPlucked2.ar(freq, amp, gate,0.1,1,c3,inp);
	var select = Select.ar(slct, [son, son + (strum * 40)]);
    DetectSilence.ar(select, 0.001, doneAction:2);
    Out.ar(out, Pan2.ar(select * 0.1, pan));
}).add;
)

Synth(\zheng2, [\slct, 1]); // Try to hear the plucked noise here

play {BPF.ar(WhiteNoise.ar(0.94), 2500, 0.01) * Env.perc(0.01, 0.001).kr } ;

// Use it.
// One flaw is if we play multiple notes too fast, like delta value with 0.2, then the server can't handle so many notes, which constrains us to implement a whole piece of this passionate instrument.
(
~note_zheng2 = [6,8,1,0.5,0.5,1,0.5,0.5,4,2,1,1];
~note_zheng = [1,-4,1,1,2,0,-5,0,0,1,2,-3,2,2,3,1,-4,1,1,2,3,-2,3,3,4,2,-3,2,2,3,4,-1,4,4,5,3,-2,3,3,4,2,-3,2,2,4,3,-2,3,3,2,1];

// Can define own Tuning here
a = Scale.new(
    #[0, 2, 4, 7, 9],
    5,
    Tuning.new([0, 1, 2, 3, 4]),
    "Custom"
);

Pbind(
    \instrument, \zheng1,
    \scale ,Scale.gong,
    \delta , Pseq([1,1,1,0.5,0.5,1,1,1,0.5,0.5,0.8,0.8,0.8,0.4,0.4,0.8,0.8,0.8,0.4,0.4,0.6,0.6,0.6,0.3,0.3,0.6,0.6,0.6,0.3,0.3,0.4,0.4,0.4,0.2,0.2,0.4,0.4,0.4,0.2,0.2,0.4,0.4,0.4,0.2,0.2,0.4,0.4,0.4,0.2,0.2]), // Use delta to control the time until next event
    \dur , 2, // dur should be the same
	\degree, Pseq(~note_zheng),
    \amp , Pwhite(0.2,0.8),
    \c3 , Pseq([Pseq([300],24),Pseq([300],24)]), // Echo effect
	\pan , [-1,1] //  channel choice
).play;

// swipe the string

Pbind(
    \instrument, \zheng2,
    \scale ,Scale.gong,
    \delta , Pseq([1,1,1,0.5,0.5,1,1,1,0.5,0.5,0.8,0.8,0.8,0.4,0.4,0.8,0.8,0.8,0.4,0.4,0.6,0.6,0.6,0.3,0.3,0.6,0.6,0.6,0.3,0.3,0.4,0.4,0.4,0.2,0.2,0.4,0.4,0.4,0.2,0.2,0.4,0.4,0.4,0.2,0.2,0.4,0.4,0.4,0.2,0.2]), // Use delta to control the time until next event
    \dur , 2, // dur should be the same
	\degree, Pseq([[-6,-5,-4,-3-2,-1,0,1,2,3,4,5,6,7],\rest,\rest,\rest,\rest],10),
	\strum, 0.01,
    \amp , Pwhite(0.2,0.8),
    \c3 , Pseq([Pseq([300],24),Pseq([300],24)]), // Echo effect
	\pan , [-1,1] //  channel choice
).play;
)


// Part 9: Wooden Knocker
s.record("/Users/xinzhang/Desktop/Sound/Wooden Knocker.wav");
s.stopRecording;
(
SynthDef(\WoodenKnocker, {|freq, dur=1|
	var knocker = Klank.ar(`[     // Klank: A bank of fixed requency resonators
		[800,  907, 1134],  // freqs
		[0.7, 0.35, 0.25],// amps
		[0.25, 0.2, 0.1]   // ring times
		]
	, Impulse.ar(0));
	Out.ar(0, Pan2.ar(CombL.ar(knocker, 0.2, 0.2, 0.2, 1, 0) * 0.9) * Line.kr(1, 1, dur, doneAction:2));
}).add;
)
(
Pbind(\instrument, \WoodenKnocker,
	\dur, Pseq([1], inf);
).play;
)


// Part 10: Temple Bell
s.record("/Users/xinzhang/Desktop/Sound/Temple Bell.wav");
s.stopRecording;
(
SynthDef(\TempleBell, {
	var perc = Env.perc(0.01, 0.04, 1, -4).ar;
	var bell = Klank.ar(`[
		[151,  250, 334],  // freqs
		[0.9, 0.6, 0.35],// amps
		[4.0, 3.3, 2.4]   // ring times
		]
	, perc);
	Out.ar(0, Pan2.ar(bell));
}).add;
)
(
Pbind(\instrument, \TempleBell,
	\dur, Pseq([4], inf),
).play;
)


// Part 11: Chinese Drum
// We've got no search result for the modal frequency ratio of this drum, and it's hard to record ourselves too, so here is the best we can do.

// Try randomness on tension and loss of membraneCircle
(
play {
	var perc = Env.perc.kr * BrownNoise.ar();
	var tension = rrand(0.01, 0.1);
	var loss = rrand(0.9, 0.9999);
	var drum = MembraneCircle.ar(perc, tension, loss);
	("      Value for tension:\t\t" + tension).postln;
	("      Value for loss:\t\t" + loss).postln;
	Out.ar(0,LPF.ar(drum,220));
}
)


// Build the drum surface and giant resonator, which gets input from the former one.
// Still sounds like some metal texture
(
SynthDef(\head, { var excitation = EnvGen.kr(Env.perc,
                            MouseButton.kr(0, 1, 0),
                             timeScale: 0.1, doneAction: 0
                            ) * PinkNoise.ar(0.4);
  var tension = 0.03;
  var loss = 0.999222;
  var sound = MembraneCircle.ar(excitation, tension, loss);
Out.ar(21, sound);
}).add;
)

x = Synth(\head);

(
SynthDef(\body, { |fund=50, inS=1, inR=1|
	var in = In.ar(21, 1);
	var reson = Klank.ar(`[[1, 1.5, 2.0, 3.01, 4.69, 5.63] * fund, [1, 0.5, 0.25, 0.35, 0.25, 0.125], [2, 2, 2, 2, 2, 2]], in) ;
	var filter = RLPF.ar(reson, fund + 4);
	var local_verb = FreeVerb.ar((in * inS) + (reson * inR), 0.2, 0.1);
	Out.ar(0, local_verb);

}).add;
)

y = Synth(\body, addAction: \addToTail);
y.set(\inR, 0.9);