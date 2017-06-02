function isVowel(char) {
  return ['a', 'i', 'e', 'o', 'u', 'y'].indexOf(char);
}

function isConsonant(char) {
  return !isVowel(char);
}

function nextVowel(str) {
  return str.split('').find(c => isVowel(c));
}

function nextConsonant(str) {
  return str.split('').find(c => isConsonant(c));
}

function getVoicedOrVoicelessVersionOf(char) {
  const version = {
    b: 'p',
    c: 'g',
    d: 't',
    f: 'v',
    g: 'k',
    h: 'h',
    j: 'j',
    k: 'g',
    l: 'l',
    m: 'l',
    n: 'n',
    p: 'b',
    q: 'q',
    r: 'r',
    s: 'z',
    t: 'd',
    v: 'f',
    w: 'w',
    x: 'x',
    z: 's',
  };
  return version[char];
}

function covfefify(original) {
  const firstVowel = nextVowel(original);
  const firstConsonantAfterFirstVowel = nextConsonant(original.substring(original.indexOf(firstVowel, original.length)));
  const firstSoundGroup = original.substring(0, firstConsonantAfterFirstVowel + 1);
  const changedConsonant = getVoicedOrVoicelessVersionOf(firstConsonantAfterFirstVowel);
  const nextVowelAfterChangedConsonant = nextVowel(original.substring(original.indexOf(firstConsonantAfterFirstVowel), original.length));
  const secondSoundGroup = changedConsonant + nextVowelAfterChangedConsonant + changedConsonant + nextVowelAfterChangedConsonant;
  return firstSoundGroup + secondSoundGroup;
}

console.log(covfefify('coverage'));
