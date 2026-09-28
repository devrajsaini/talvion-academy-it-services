(function(){
  function initTalvionRoadmap(){
    var roadmap=document.querySelector('.tv-roadmap');
    if(!roadmap) return;
    var steps=roadmap.querySelectorAll('.tv-road-step');
    if('IntersectionObserver' in window){
      var observer=new IntersectionObserver(function(entries){
        entries.forEach(function(entry){
          if(entry.isIntersecting){
            roadmap.classList.add('is-visible');
            steps.forEach(function(step){step.classList.add('tv-visible');});
            observer.unobserve(entry.target);
          }
        });
      },{threshold:.22});
      observer.observe(roadmap);
    }else{
      roadmap.classList.add('is-visible');
      steps.forEach(function(step){step.classList.add('tv-visible');});
    }
  }
  if(document.readyState==='loading') document.addEventListener('DOMContentLoaded',initTalvionRoadmap); else initTalvionRoadmap();
})();

(function(){
  function initCoreArchitecture(){
    var section=document.querySelector('.tv-core-architecture');
    if(!section) return;
    if('IntersectionObserver' in window){
      var observer=new IntersectionObserver(function(entries){
        entries.forEach(function(entry){
          if(entry.isIntersecting){
            section.classList.add('is-visible');
            observer.unobserve(section);
          }
        });
      },{threshold:.16});
      observer.observe(section);
    }else{
      section.classList.add('is-visible');
    }
  }
  if(document.readyState==='loading') document.addEventListener('DOMContentLoaded',initCoreArchitecture); else initCoreArchitecture();
})();
