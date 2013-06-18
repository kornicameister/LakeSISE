package org.kornicameister.sise.lake.types.actors.impl.ts;

import org.kornicameister.sise.lake.types.actors.DefaultActor;
import org.kornicameister.sise.lake.types.actors.LakeActors;

public class PoacherActorTS extends DefaultActor {
	
	public PoacherActorTS () {
		super();
		}
		
	@Override
	protected LakeActors setType() {
		return LakeActors.POACHER;
		}
		
	@Override
	public void run() {
		}
	
	@Override
	public String getFactName() {
		return PoacherActorTS.class.getSimpleName();
		}
}
