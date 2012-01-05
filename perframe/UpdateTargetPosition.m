function UpdateTargetPosition(targettype,hfly,hfly_extra,pos)
switch targettype,
  case 'fly',
    updatefly(hfly,pos.x,pos.y,pos.theta,pos.a,pos.b);
  case 'larva',
    set(hfly,'XData',pos.skeletonx,'YData',pos.skeletony);
    set(hfly_extra,'XData',pos.skeletonx(1),'YData',pos.skeletony(1));
end