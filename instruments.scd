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
~notes_2_2 = Array.fill(20, {[62,62,64,76]});
~notes_2_3 = Array.fill(20, {[62,62,62,76]});
~notes_2 = ~notes_2 ++ ~notes2_2 ++ ~notes2_3;
~dur_2 = Array.fill(80,{0.05});
~notes_3 = Array.fill(40, {[48,50,72]});
~dur_3 = Array.fill(40,{0.05});
~notes_4 = Array.fill(40, {[48,50,74]});
~dur_4 = Array.fill(40,{0.05});
~notes_5 = Array.fill(5, {[48,50,71]});
~dur_5 = Array.fill(5, {0.05});
~notes = ~notes_1 ++ ~notes_2 ++ ~notes_3 ++ ~notes_4 ++ ~notes_5;
~dur= ~dur_1 ++ ~dur_2 ++ ~dur_3 ++ ~dur_4 ++ ~dur_5;




// Section 3


(
a = Pdef(\kspattern,
		Pbind(\instrument, \ks_guitar, // using our sine synthdef
		\note, Pseq.new(~notes).midicps, // freq arg
		\dur, Pseq.new(~dur),  // dur arg
		\sustain, 2,
		\rand, Pseq.new([0.51, 0.51, 0.51, 0.51, 0.81], inf),  // dur arg
		\pan, [0,1],
		\strum, Pseq([0.01, 0.01, 0.01, 0.01, 0.01], inf),
		\low, 600,
		\lower, 1200,
		\mid, 3600,
		\high, 4800,
		\delayTime, 0.91;  // decay time
		)
).play;)
)
(
b = Pdef(\kspattern,
		Pbind(\instrument, \ks_guitar, // using our sine synthdef
		\note, Pseq.new(~notes_1, inf).midicps, // freq arg
		\dur, Pseq.new([0.06, 0.06, 0.06, 0.06, 1.36, 0.05, 0.05, 0.05, 0.05, 0.96, 0.05, 0.05, 0.05, 0.05, 0.56, 0.05, 0.05, 0.05, 0.05, 0.26, 0.05, 0.05, 0.05, 0.05, 0.06, 0.05, 0.05, 0.05, 0.05, 0.06, 0.05, 0.05, 0.05, 0.05, 0.06, 0.05, 0.05, 0.05, 0.05, 0.05, 0.05, 0.05, 0.05, 0.05, 0.05,0.05,0.05,0.05,0.05,0.05,0.05,0.05,0.05,0.05,0.05,0.05,0.05,0.05,0.05,0.05,0.05,0.05,0.05,0.05,0.05,0.05], inf),  // dur arg
		\sustain, 2,
		\rand, Pseq.new([0.41, 0.41, 0.41, 0.41, 0.71, 0.41, 0.41, 0.41, 0.41, 0.71, 0.51, 0.51, 0.51, 0.51, 0.81, 0.56, 0.56, 0.56, 0.56, 0.81, 0.46,0.46,0.46,0.46,0.71], inf),  // dur arg
		\pan, [0,1],
		\strum, Pseq([0.01, 0.01, 0.01, 0.01, 0.03, 0.01, 0.01, 0.01, 0.01, 0.03, 0.01, 0.01, 0.01, 0.01, 0.02, 0.01, 0.01, 0.01, 0.01, 0.01,0.001,0.001,0.001,0.001,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0], inf),
		\low, 600,
		\lower, 1200,
		\mid, 3600,
		\high, 6400,
		\delayTime, 0.91;  // decay time

		)
).play;)

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
	// wind rq 调整使风声变小
	var windspd, snd;
	windspd = LFDNoise3.kr(LFNoise1.kr(1, 0.5, 0.5), 0.5, 0.5);
	snd = Pan2.ar(RLPF.ar(in:WhiteNoise.ar(), freq:windspd * 500 + 250, rq:LFNoise1.kr(1, 0.3, 0.5), mul:windspd * 0.5), LFDNoise3.kr(0.4, 0.5));
	Out.ar(0, snd);
}).add;

Synth(\wind);

// Part 3: Xiao sound
// Granular synthesis
(
// Goal 1: 使用箫吹段旋律
// Goal 2: 使用箫吹短音做装饰
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
 \freq, Prand([60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 50], inf).midicps,
 \dur, Prand([1, 2, 3], inf) * 0.5,
).play;

// Part 4: Voicetest
// buffer in 一个音频文件然后调整成念经效果 BALLPASS


// Part 5: water (rain drop)


(
SynthDef(\bubblebub, { |out=0, t_trig=1, attack=0.01, decay=0.08, pitchcurvelen=0.1, freq=700, doneAction=0, amp=0.1|
 var pitch, son;
 amp   = amp * EnvGen.ar(Env.perc(attack, decay).delay(0.003), t_trig, doneAction: doneAction);
 pitch = freq * EnvGen.ar(Env.new([0,0,1],[0,1]).exprange(1, 2.718), t_trig, timeScale: pitchcurvelen);
 son = SinOsc.ar(pitch);
 // high-pass to remove any lowpitched artifacts, scale amplitude
 son = HPF.ar(son, 500) * amp * 10;
 son = FreeVerb.ar(son);
 Out.ar(out, son);
}).store
)


x = Synth(\bubblebub);

// Part 6: Leaf sound
// 改成synthdef然后用dur控制时间长短
{HPF.ar(WhiteNoise.ar, 1000) * LFNoise2.kr(1).squared.squared}.play;

{HPF.ar(WhiteNoise.ar, 1000) * LFNoise2.kr(0.5, 0.5).squared.squared}.play;

// Part 7: Sword sound
(
// 改perc和timeScale
SynthDef(\sword, {
 var excitation = EnvGen.kr(Env.perc, timeScale: 0.6, doneAction: 2) * WhiteNoise.ar(0.5);
 var tension = 0.1;
 var loss = 0.999999999;
 var snd = MembraneHexagon.ar(excitation, tension, loss);
 // snd = HPF.ar(snd, 2000);
 snd = BPF.ar(snd, 3000, 0.2 );
 snd = RHPF.ar(snd, 3000, 0.1);
 snd = Decay.ar(snd, 0.9);
 Out.ar(0, snd);

}).add;

Synth(\sword);
)



// Part 8: Wooden Knocker

(
SynthDef(\WoodenKnocker, {|lowFreq = 800, midFreq = 907, highFreq = 1134|
	var knocker = Klank.ar(`[     // Klank: A bank of fixed requency resonators
		[lowFreq,  midFreq, highFreq],  // freqs
		[0.7, 0.35, 0.25],// amps
		[0.25, 0.2, 0.1]   // ring times
		]
	, Impulse.ar(0));
	Out.ar(0, Pan2.ar(CombL.ar(knocker, 0.2, 0.2, 0.2, 1, 0) * 0.9));
}).add;
Synth(\WoodenKnocker, [\lowFreq, 800, \midFreq, 907, \highFreq, 1134]);
)

// Part 9: Temple Bell
(
SynthDef(\TempleBell, {|lowFreq, midFreq, highFreq|
	var perc = Env.perc(0.01, 0.04, 1, -4).ar;
	var bell = Klank.ar(`[
		[lowFreq,  midFreq, highFreq],  // freqs
		[0.9, 0.6, 0.35],// amps
		[4.0, 3.3, 2.4]   // ring times
		]
	, perc);
	Out.ar(0, Pan2.ar(bell * 0.2));
}).add;
Synth(\TempleBell, [\lowFreq, 151, \midFreq, 250, \highFreq, 334]);
)

// Part 10: Zheng
(
SynthDef(\help_dwgplucked, { |out=0, freq=440, amp=0.5, gate=1, c3=20, pan=0|
    var env = Env.new([0,1, 1, 0],[0.001,0.006, 0.0005],[5,-5, -8]);
    var inp = amp * LFClipNoise.ar(2000) * EnvGen.ar(env,gate);
    var son = DWGPlucked2.ar(freq, amp, gate,0.1,1,c3,inp);
    DetectSilence.ar(son, 0.001, doneAction:2);
    Out.ar(out, Pan2.ar(son * 0.1, pan));
}).add;
)

// version 2 - with extra plectrum noise
(
SynthDef(\help_dwgplucked, { |out=0, freq=440, amp=0.5, gate=1, c3=20, pan=0, slct=1|
    var env = Env.new([0,1, 1, 0],[0.001,0.006, 0.0005],[5,-5, -8]);
    var inp = amp * LFClipNoise.ar(2000) * EnvGen.ar(env,gate);
	var strum = BPF.ar(WhiteNoise.ar(0.94), 2500, 0.01) * Env.perc(0.01, 0.001).kr;
	var son = DWGPlucked2.ar(freq, amp, gate,0.1,1,c3,inp);
	var select = Select.ar(slct, [son, son + (strum * 40)]);
    DetectSilence.ar(select, 0.001, doneAction:2);
    Out.ar(out, Pan2.ar(select * 0.1, pan));
}).add;
)

Synth(\help_dwgplucked, [\slct, 1])

play {BPF.ar(WhiteNoise.ar(0.94), 2500, 0.01) * Env.perc(0.01, 0.001).kr } ;


//Use it.
(
a = Scale.new(
    #[0, 2, 4, 7, 9],
    5,
    Tuning.new([0, 0.75, 3, 3.5, 3]),
    "Custom"
);




Pbind(
    \instrument, \help_dwgplucked,
    \scale ,Scale.gong,
    \delta , Pseq([4,0.5,0.5,0.5,0.5,0.5,0.5,1,0.5,0.5,1,1]*0.2,inf), // Use delta to control the time until next event
    \dur , 2, // dur should be the same
	\degree, Pseq([[0,1,2,3],4,5,6,7,8,9,10],inf),//Pseq([4,5,6,4,5,3,4,2,2,2,4,5,3,4,3,2,1,1,2,1,2,3,4,2,3,3,1,0], inf),
    \amp , Pwhite(0.2,0.8),
    \c3 , Pseq([Pseq([300],24),Pseq([300],24)],inf), // Echo effect
	\pan , [0,1] //  channel choice
).play;
)

// Part 11: Chinese Drum
(
SynthDef(\ChineseDrumMain, {
	var perc = Env.perc.kr * WhiteNoise.ar();
	var tension = rrand(0.01, 0.05);
	var loss = rrand(0.999, 0.99999);
	var drum = MembraneCircle.ar(perc, tension, loss);
	("      Value for tension:\t\t" + tension).postln;
	("      Value for loss:\t\t" + loss).postln;
}).add;
Synth(\ChineseDrumMain);
)

(
play{
	var perc = Env.perc.kr * BrownNoise.ar();
	var tension = rrand(0.01, 0.1);
	var loss = rrand(0.9, 0.9999);
	var drum = MembraneCircle.ar(perc, tension, loss);
	("      Value for tension:\t\t" + tension).postln;
	("      Value for loss:\t\t" + loss).postln;
	Out.ar(0,LPF.ar(drum,220));
}
)

(
~woodBar = [1, 2.572, 4.644, 6.984, 9.723, 12] ;  // uniform wooden bar
~alumBar = [1, 2.756, 5.423, 8.988, 13.448, 18.680]; // uniform aluminum bar
~bayunTabla = [1, 2.0, 3.01, 4.01, 4.69, 5.63]; // Bayan tabla
)

(

~baseFreq = 2000;
//~freqs = ~woodBar * ~baseFreq;
~freqs = ~alumBar * ~baseFreq;
//~freqs = ~bayunTabla * ~baseFreq;
~amps = [0.5, 0.2, 0.125, 0.0125, 0.0235, 0.0125 ];
~ring = [1.6,1.3,1.0,0.7, 0.5, 0.3];

~low = rrand(200, 1800);
~mid = rrand(2000, 4000);
~high = rrand(4500, 6500);
~lq = 0.6;
~mq = 0.35;
~hq = 0.35;

play {

	// exciters:
	var perc = Env.perc.kr * WhiteNoise.ar();
	var noise = PinkNoise.ar(0.1);
	var filt = BPF.ar(noise, ~low, ~lq) + BPF.ar(noise, ~mid, ~mq) + BPF.ar(noise, ~high, ~hq);
	var pluck = Pluck.ar(filt, 1, ~baseFreq.reciprocal, ~baseFreq.reciprocal, 0.25);  // if brownnoise is .kr... just... wtf...

	var drum = MembraneCircle.ar(perc, 0.5, 0.99, 0.125);  // model contains resonator?..

	// modal resonator: change input after array
	var rsntr = Klank.ar(`[~freqs, ~amps, ~ring], pluck);
	Out.ar(0, rsntr);
}
)

(
SynthDef(\head, { var excitation = EnvGen.kr(Env.perc,
                            MouseButton.kr(0, 1, 0),
                             timeScale: 0.1, doneAction: 0
                            ) * PinkNoise.ar(0.4);
  var tension = MouseX.kr(0.01, 0.1);
  var loss = MouseY.kr(0.999999, 0.999, 1);
  var sound = MembraneCircle.ar(excitation, tension, loss);
Out.ar(21, sound);
}).add;
)

x = Synth(\head);

SynthDef(\body, { |fund=50, inS=1, inR=1|
	var in = In.ar(21, 1);
	var reson = Klank.ar(`[[1, 2.0, 3.01, 4.01, 4.69, 5.63] * fund, [1, 0.5, 0.25, 0.35, 0.25, 0.125], [2, 2, 2, 2, 2, 2]], in) ;
	var filter = RLPF.ar(reson, fund + 4);
	var local_verb = FreeVerb.ar((in * inS) + (reson * inR), 0.2, 0.1);
	Out.ar(0, local_verb);

}).add;

y = Synth(\body, addAction: \addToTail);


y.set(\inR, 0.9);