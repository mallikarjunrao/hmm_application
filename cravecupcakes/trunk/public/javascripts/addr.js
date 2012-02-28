//output email
function e (name, dom) {
  if (dom == "studio") {
    var sufx = '@st';
    sufx += 'udiocommunications.net';
  } else {
    var sufx = '@cra';
    sufx += 'vecupcakes.com';	
  }
  return name + sufx;
}
function m (name, sub, domn) {
  var prot = 'ma';
  prot += 'ilto:';
  var a = '?sub';
  a += 'ject=' + sub;
  return prot + e (name, domn) + a;
}
function m2 (name, subj) {
  window.location.href = m (name, subj);
}
function mtag (name, link, subj, domn) {
  if (link == "") {
    return '<a style="font-size:100%;" href="' + m (name, subj, domn) + '">' + e (name, domn) + '</a>';
  } else {
    return '<a style="font-size:100%;" href="' + m (name, subj, domn) + '">' + link + '</a>';
  }
}