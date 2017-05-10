package structures;

import java.util.ArrayList;


/**
 * This class is a repository of sorting methods used by the interval tree.
 * It's a utility class - all methods are static, and the class cannot be instantiated
 * i.e. no objects can be created for this class.
 * 
 * @author runb-cs112
 */
public class Sorter {

	private Sorter() { }
	
	/**
	 * Sorts a set of intervals in place, according to left or right endpoints.  
	 * At the end of the method, the parameter array list is a sorted list. 
	 * 
	 * @param intervals Array list of intervals to be sorted.
	 * @param lr If 'l', then sort is on left endpoints; if 'r', sort is on right endpoints
	 */
	public static void sortIntervals(ArrayList<Interval> intervals, char lr) {
		int tracker = 0;
		if(lr == 'l')
		{
			for(int index = 1; index < intervals.size(); index++)
			{
				Interval curr = intervals.get(index);
				for(tracker = index-1; (intervals.get(tracker).leftEndPoint > curr.leftEndPoint) && (tracker > -1); tracker--)
				{
					intervals.set(tracker+1, intervals.get(tracker));
//					intervals.remove(tracker+1);
//					intervals.add(tracker+1, intervals.get(tracker));
				}
				intervals.set(tracker+1, curr);
//				intervals.remove(tracker+1);
//				intervals.add(tracker+1, curr);
			}
		}
		else if (lr == 'r')
		{
			for(int index = 1; index < intervals.size(); index++)
			{
				Interval curr = intervals.get(index);
				for(tracker = index-1; (intervals.get(tracker).rightEndPoint > curr.rightEndPoint) && (tracker > -1); tracker--)
				{
					intervals.set(tracker+1, intervals.get(tracker));
//					intervals.remove(tracker+1);
//					intervals.add(tracker+1, intervals.get(tracker));
				}
				intervals.set(tracker+1, curr);
//				intervals.remove(tracker+1);
//				intervals.add(tracker+1, curr);
			}
		}
	}
	
	/**
	 * Given a set of intervals (left sorted and right sorted), extracts the left and right end points,
	 * and returns a sorted list of the combined end points without duplicates.
	 * 
	 * @param leftSortedIntervals Array list of intervals sorted according to left endpoints
	 * @param rightSortedIntervals Array list of intervals sorted according to right endpoints
	 * @return Sorted array list of all endpoints without duplicates
	 */
	public static ArrayList<Integer> getSortedEndPoints(ArrayList<Interval> leftSortedIntervals, ArrayList<Interval> rightSortedIntervals) {
		ArrayList<Integer> newArray = new ArrayList<Integer>();
		newArray.add(leftSortedIntervals.get(0).leftEndPoint); //adds very first endpoint, assuming that the given arraylists are indeed sorted.
		
		for(int index1 = 1; index1 < leftSortedIntervals.size(); index1++)
		{
			if(leftSortedIntervals.get(index1-1).leftEndPoint == leftSortedIntervals.get(index1).leftEndPoint) //find duplicates
			{
				continue;
			}
			else
			{
				newArray.add(leftSortedIntervals.get(index1).leftEndPoint);
			}
		}
		newArray.add(rightSortedIntervals.get(0).rightEndPoint);
		for(int index2 = 1; index2 < rightSortedIntervals.size(); index2++)
		{
			if(rightSortedIntervals.get(index2-1).rightEndPoint == rightSortedIntervals.get(index2).rightEndPoint) //find duplicates
			{
				continue;
			}
			else
			{
				newArray.add(rightSortedIntervals.get(index2).rightEndPoint);
			}
		}
		//sorts the ArrayList in ascending order.
		int tracker = 0;
		for(int index = 1; index < newArray.size(); index++)
		{
			Integer current = newArray.get(index);
			for(tracker = index-1; (newArray.get(tracker) > current) && (tracker > -1); tracker--)
			{
				newArray.set(tracker+1, newArray.get(tracker));
			}
			newArray.set(tracker+1, current);
		}
		//removes duplicates.
		int prev = 0;
		for(int index3 = 1; index3 < newArray.size(); index3++)
		{
			if(newArray.get(prev) == newArray.get(index3))
			{
				newArray.remove(prev);
				index3--;
			}
			prev = index3;
		}		
		return newArray;
	}
}
