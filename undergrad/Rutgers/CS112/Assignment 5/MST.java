package apps;

import structures.*;
import java.util.ArrayList;


public class MST {
	
	/**
	 * Initializes the algorithm by building single-vertex partial trees
	 * 
	 * @param graph Graph for which the MST is to be found
	 * @return The initial partial tree list
	 */
	public static PartialTreeList initialize(Graph graph) {
	
		PartialTreeList list = new PartialTreeList();
		for(int i = 0; i < graph.vertices.length; i++)
		{
			PartialTree tmp = new PartialTree(graph.vertices[i]);
			
			while(graph.vertices[i].neighbors != null)
			{
				
				tmp.getArcs().insert(new PartialTree.Arc(graph.vertices[i],graph.vertices[i].neighbors.vertex,graph.vertices[i].neighbors.weight));
				graph.vertices[i].neighbors = graph.vertices[i].neighbors.next;
			}
			
			list.append(tmp);
		}
		
		//DEBUGGING////////////////////////////////////////////////////////
//		for(PartialTree tmp: list){
//			System.out.println(tmp);
//		}
		///////////////////////////////////////////////////////////////////
		
		
		
		
		
		return list;
	}

	/**
	 * Executes the algorithm on a graph, starting with the initial partial tree list
	 * 
	 * @param graph Graph for which MST is to be found
	 * @param ptlist Initial partial tree list
	 * @return Array list of all arcs that are in the MST - sequence of arcs is irrelevant
	 * NOTE: This list is the list of arcs that don't belong to the MST.
	 */
	public static ArrayList<PartialTree.Arc> execute(Graph graph, PartialTreeList ptlist) {
		
		ArrayList<PartialTree.Arc> list = new ArrayList<PartialTree.Arc>();	
		while(ptlist.size()>1)
		{
		System.out.println("Size of ptlist: "+ptlist.size());
		for(PartialTree tmp: ptlist)
		{
		System.out.println(tmp);
		}
		//Let vertices v1 and v2 be the two vertices connected by alpha, where v1 belongs to PTX. AKA Step 4
			PartialTree PTX = ptlist.remove();
			PartialTree.Arc alpha = PTX.getArcs().deleteMin();
			Vertex v2 = alpha.v2;
			Vertex v1 = alpha.v1;
			System.out.println("After assigning PTX: ");
			for(PartialTree tmp: ptlist)
			{
			System.out.println(tmp);
			}
			
		//If v2 also belongs to PTX, go back to Step 4.
			for(PartialTree.Arc arc : PTX.getArcs())
			{
				if(v2.equals(arc.v1) || (v1.equals(arc.v2)))
				{
					alpha = PTX.getArcs().getMin(); //finds next arc.
					v2 = alpha.v2;
				}
			}
			list.add(alpha);
			System.out.println("List now contains: "+list);
			
			
		//Next, find the partial Tree PTY to which v2 belongs.
			//Remove PTY from ptlist.
			System.out.println("We are looking for a tree that contains: "+v2);
			System.out.println("Trees remaining are: ");
			for(PartialTree tmp: ptlist)
			{
			System.out.println(tmp);
			}
			
			
			PartialTree PTY = ptlist.removeTreeContaining(v2);
			System.out.println("Trees remaining (Post removal) are: \n\n");
			for(PartialTree tmp: ptlist)
			{
			System.out.println(tmp);
			}
		//Merge PTX and PTY, along with their priority queues. Append the resulting tree to the end of the list.
		
			PTX.merge(PTY);
			System.out.println("PTX post merge: "+PTX);
			System.out.println("Size: "+ptlist.size());
			ptlist.append(PTX);
			System.out.println("Size is now: "+ptlist.size());
			System.out.println("Trees remaining (finalized) are: ");
			for(PartialTree tmp: ptlist)
			{
			System.out.println(tmp);
			}
			System.out.println("/////////////////////////////////////////////////////////////////////////////////");
		}
			System.out.println("FINAL Tree left: ");
			for(PartialTree tmp: ptlist)
			{
			System.out.println(tmp);
			}
			System.out.println("List is: "+list);
		
		return list;
	}
}

