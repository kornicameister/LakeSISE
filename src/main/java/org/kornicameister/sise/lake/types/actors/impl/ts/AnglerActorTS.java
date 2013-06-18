package org.kornicameister.sise.lake.types.actors.impl.ts;

import org.kornicameister.sise.lake.types.actors.DefaultActor;
import org.kornicameister.sise.lake.types.actors.LakeActors;

public class AnglerActorTS extends DefaultActor {

	public AnglerActorTS () {
		super();
		}
		
	@Override
	protected LakeActors setType() {
		return LakeActors.ANGLER;
		}
		
	@Override
	public void run() {
		}
	
	@Override
	public String getFactName() {
		return AnglerActorTS.class.getSimpleName();
		}
}