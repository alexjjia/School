package structures;

import java.util.*;

/**
 * Encapsulates an interval tree.
 * 
 * @author runb-cs112
 */
public class IntervalTree {
	
	/**
	 * The root of the interval tree
	 */
	IntervalTreeNode root;
	
	/**
	 * Constructs entire interval tree from set of input intervals. Constructing the tree
	 * means building the interval tree structure and mapping the intervals to the nodes.
	 * 
	 * @param intervals Array list of intervals for which the tree is constructed
	 */
	public IntervalTree(ArrayList<Interval> intervals) {
		
		// make a copy of intervals to use for right sorting
		ArrayList<Interval> intervalsRight = new ArrayList<Interval>(intervals.size());
		for (Interval iv : intervals) {
			intervalsRight.add(iv);
		}
		// rename input intervals for left sorting
		ArrayList<Interval> intervalsLeft = intervals;
		
		// sort intervals on left and right end points
		Sorter.sortIntervals(intervalsLeft, 'l');
		Sorter.sortIntervals(intervalsRight,'r');
		
		// get sorted list of end points without duplicates
		ArrayList<Integer> sortedEndPoints = Sorter.getSortedEndPoints(intervalsLeft, intervalsRight);
		// build the tree nodes
		root = buildTreeNodes(sortedEndPoints);
		
		System.out.println("Root is currently: "+root);
		
		// map intervals to the tree nodes
		mapIntervalsToTree(intervalsLeft, intervalsRight);
	}
	
	/**
	 * Builds the interval tree structure given a sorted array list of end points.
	 * See Steps 5 and 6
	 * @param endPoints Sorted array list of end points
	 * @return Root of the tree structure
	 */
	public static IntervalTreeNode buildTreeNodes(ArrayList<Integer> endPoints) {
		Queue<IntervalTreeNode> Q = new Queue<IntervalTreeNode>();
		for(int pindex = 0; pindex < endPoints.size(); pindex++)
		{
			//creates a new tree.
			IntervalTreeNode tree = new IntervalTreeNode(endPoints.get(pindex), endPoints.get(pindex), endPoints.get(pindex));
			Q.enqueue(tree);
		}

		return actuallyBuildingTreeNodes(Q);
	}
	private static IntervalTreeNode actuallyBuildingTreeNodes(Queue<IntervalTreeNode> Q)
	{
		if(Q.size() == 1)
		{
			return Q.dequeue();
		}
		int Qsize = Q.size();
		while(Qsize > 1)
		{
			 IntervalTreeNode T1 = Q.dequeue();
			 IntervalTreeNode T2 = Q.dequeue();
			 
			 float v1 = findMax(T1);
			 float v2 = findMin(T2);
			IntervalTreeNode N = new IntervalTreeNode((v1+v2)/2,v2,v1);
		
			//	System.out.println("N's splitvalue is: "+N.splitValue+", minSplit is: "+N.minSplitValue+", maxSplit is: "+N.maxSplitValue);
			 N.leftChild = T1;
			 N.rightChild = T2;
			 Q.enqueue(N);
			 Qsize-=2; 
		}
		if(Qsize == 1)
		{
			Q.enqueue(Q.dequeue()); //at this point, I have a gigantic super tree.
		}	
		return actuallyBuildingTreeNodes(Q);
	}
	private static float findMax(IntervalTreeNode node)
	{
		if(node.rightChild != null)
			return findMax(node.rightChild);
		else
		{
			return node.maxSplitValue;
		}
	}
	private static float findMin(IntervalTreeNode node)
	{
		if(node.leftChild != null)
			return findMin(node.leftChild);
		else
		{
			return node.minSplitValue;
		}
	}
	
	
	/**
	 * Maps a set of intervals to the nodes of this interval tree. 
	 * AKA STEP 7
	 * @param leftSortedIntervals Array list of intervals sorted according to left endpoints
	 * @param rightSortedIntervals Array list of intervals sorted according to right endpoints
	 */
	public void mapIntervalsToTree(ArrayList<Interval> leftSortedIntervals, ArrayList<Interval> rightSortedIntervals) {
		IntervalTreeNode T = root;
		
		for(Interval interval1 : leftSortedIntervals)
		{
			IntervalTreeNode N = searchMapNode(T, interval1);
			if(N.leftIntervals == null)
			{N.leftIntervals = new ArrayList<Interval>();}		
			if(searchMapIntervals(T, interval1) != null)
			{
				N.leftIntervals.add(interval1);
			}
		}
		for(Interval interval2 : rightSortedIntervals)
		{
			IntervalTreeNode N = searchMapNode(T, interval2);
			if(N.rightIntervals == null)
			{N.rightIntervals = new ArrayList<Interval>();}
			if(searchMapIntervals(T, interval2)!= null)
			{
				N.rightIntervals.add(interval2);
			}
		}
//		System.out.println("Left Intervals: "+T.leftIntervals);
//		System.out.println("Right Intervals: "+T.rightIntervals);
	}	
	private Interval searchMapIntervals(IntervalTreeNode N, Interval interval)
	{
		if(interval == null)
		{
			return null;
		}
		else if((interval.leftEndPoint < N.splitValue) && (interval.rightEndPoint >= N.splitValue))
		{
			return interval;
		}
		else
		{
			if(interval.rightEndPoint < N.splitValue)
			{
				return searchMapIntervals(N.leftChild, interval);
			}
			else
			{
				return searchMapIntervals(N.rightChild, interval);
			}
		}
	}
	private IntervalTreeNode searchMapNode(IntervalTreeNode N, Interval interval)
	{
		if(interval == null)
		{
			return null;
		}
		else if((interval.leftEndPoint < N.splitValue) && (interval.rightEndPoint >= N.splitValue))
		{
			//initializes the l and r lists for each N found.
//			N.leftIntervals = new ArrayList<Interval>();
//			N.rightIntervals = new ArrayList<Interval>();
			return N;
		}
		else
		{
			if(interval.rightEndPoint < N.splitValue)
			{
				return searchMapNode(N.leftChild, interval);
			}
			else
			{
				return searchMapNode(N.rightChild, interval);
			}
		}
	}
	/**
	 * Gets all intervals in this interval tree that intersect with a given interval.
	 * See the part on how to QUERY AN INTERVAL TREE
	 * @param q The query interval for which intersections are to be found
	 * @return Array list of all intersecting intervals; size is 0 if there are no intersections
	 */
	public ArrayList<Interval> findIntersectingIntervals(Interval q) {
		return Query(root, q);
	}
	private ArrayList<Interval> Query(IntervalTreeNode node,Interval q) {
		ArrayList<Interval> resultList = new ArrayList<Interval>();
		ArrayList<Interval> leftQueryList = new ArrayList<Interval>();
		ArrayList<Interval> rightQueryList = new ArrayList<Interval>();
		IntervalTreeNode R = root;
		float splitVal = R.splitValue;
		ArrayList<Interval> Llist = R.leftIntervals;
		ArrayList<Interval> Rlist = R.rightIntervals;
		IntervalTreeNode Lsub = R.leftChild;
		IntervalTreeNode Rsub = R.rightChild;
		
		if(Lsub == null && Rsub == null) //meaning that R is null
		{
			return resultList;
		}
		if(q.contains(splitVal)) //meaning that splitval is within q.
		{
			for (Interval leftInterval: Llist)
			{
				resultList.add(leftInterval);
			}
			for(Interval rightInterval: Rlist)
			{
				resultList.add(rightInterval);
			}
			leftQueryList = Query(Lsub, q);
			rightQueryList = Query(Rsub, q);
			//adds back to what we wanna return
			for(Interval left: leftQueryList)
			{
				resultList.add(left);
			}
			for(Interval right: rightQueryList)
			{
				resultList.add(right);
			}	
		}
		else if(splitVal < q.leftEndPoint)
		{
			int i = Rlist.size()-1;
			while(i >=0 && Rlist.get(i).intersects(q))
			{
				resultList.add(Rlist.get(i));
				i--;
			}
			resultList.addAll(Query(Rsub,q));
		}
		else if (splitVal>q.rightEndPoint)
		{
			int i = 0;
			while(i < Llist.size() && Llist.get(i).intersects(q))
			{
				resultList.add(Llist.get(i));
				i++;
			}
			resultList.addAll(Query(Lsub,q));
		}
		return resultList;
	}
	/**
	 * Returns the root of this interval tree.
	 * 
	 * @return Root of interval tree.
	 */
	public IntervalTreeNode getRoot() {
		return root;
	}
}

