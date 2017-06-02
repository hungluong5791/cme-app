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

function covfefify(original) {
  let firstVowel = nextVowel(original);
  let firstConsonantAfterFirstVowel = nextConsonant(original.substring(original.indexOf(firstVowel, original.length)));
  let firstSoundGroup = original.substring(0, firstConsonantAfterFirstVowel + 1);
}
