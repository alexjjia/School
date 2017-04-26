package poly;

import java.io.*;
import java.util.StringTokenizer;

/**
 * This class implements a term of a polynomial.
 * 
 * @author runb-cs112
 *
 */
class Term {
	/**
	 * Coefficient of term.
	 */
	public float coeff;
	
	/**
	 * Degree of term.
	 */
	public int degree;
	
	/**
	 * Initializes an instance with given coefficient and degree.
	 * 
	 * @param coeff Coefficient
	 * @param degree Degree
	 */
	public Term(float coeff, int degree) {
		this.coeff = coeff;
		this.degree = degree;
	}
	
	/* (non-Javadoc)
	 * @see java.lang.Object#equals(java.lang.Object)
	 */
	public boolean equals(Object other) {
		return other != null &&
		other instanceof Term &&
		coeff == ((Term)other).coeff &&
		degree == ((Term)other).degree;
	}
	
	/* (non-Javadoc)
	 * @see java.lang.Object#toString()
	 */
	public String toString() {
		if (degree == 0) {
			return coeff + "";
		} else if (degree == 1) {
			return coeff + "x";
		} else {
			return coeff + "x^" + degree;
		}
	}
}

/**
 * This class implements a linked list node that contains a Term instance.
 * 
 * @author runb-cs112
 *
 */
class Node {
	
	/**
	 * Term instance. 
	 */
	Term term;
	
	/**
	 * Next node in linked list. 
	 */
	Node next;
	
	/**
	 * Initializes this node with a term with given coefficient and degree,
	 * pointing to the given next node.
	 * 
	 * @param coeff Coefficient of term
	 * @param degree Degree of term
	 * @param next Next node
	 */
	public Node(float coeff, int degree, Node next) {
		term = new Term(coeff, degree);
		this.next = next;
	}
}

/**
 * This class implements a polynomial.
 * 
 * @author runb-cs112
 *
 */
public class Polynomial {
	
	/**
	 * Pointer to the front of the linked list that stores the polynomial. 
	 */ 
	Node poly;
	
	/** 
	 * Initializes this polynomial to empty, i.e. there are no terms.
	 *
	 */
	public Polynomial() {
		poly = null;
	}
	
	/**
	 * Reads a polynomial from an input stream (file or keyboard). The storage format
	 * of the polynomial is:
	 * <pre>
	 *     <coeff> <degree>
	 *     <coeff> <degree>
	 *     ...
	 *     <coeff> <degree>
	 * </pre>
	 * with the guarantee that degrees will be in descending order. For example:
	 * <pre>
	 *      4 5
	 *     -2 3
	 *      2 1
	 *      3 0
	 * </pre>
	 * which represents the polynomial:
	 * <pre>
	 *      4*x^5 - 2*x^3 + 2*x + 3 
	 * </pre>
	 * 
	 * @param br BufferedReader from which a polynomial is to be read
	 * @throws IOException If there is any input error in reading the polynomial
	 */
	public Polynomial(BufferedReader br) throws IOException {
		String line;
		StringTokenizer tokenizer;
		float coeff;
		int degree;
		
		poly = null;
		
		while ((line = br.readLine()) != null) {
			tokenizer = new StringTokenizer(line);
			coeff = Float.parseFloat(tokenizer.nextToken());
			degree = Integer.parseInt(tokenizer.nextToken());
			poly = new Node(coeff, degree, poly);
		}
	}
	
	/**
	 * Returns the polynomial obtained by adding the given polynomial p
	 * to this polynomial - DOES NOT change this polynomial
	 * 
	 * @param p Polynomial to be added
	 * @return A new polynomial which is the sum of this polynomial and p.
	 */
	public Polynomial add(Polynomial p) {	
		Polynomial newPoly = new Polynomial();
		Node index = this.poly;
		Node index2 = p.poly;
		Node nPindex = newPoly.poly;
		
		while(index!=null ^ index2!=null) //one or the other, but NOT both are NOT EMPTY.
		{
			if(index == null)
			{
				nPindex = new Node((index2.term.coeff), index2.term.degree, nPindex);
				newPoly.poly = nPindex;
				index2=index2.next;
			}
			else if(index2 ==null)
			{
//				System.out.println("This is p: "+p);
				nPindex = new Node((index.term.coeff), index.term.degree, nPindex);
				newPoly.poly = nPindex;
				index = index.next;
				
			}
			newPoly.poly = nPindex;
		}		
		while(index !=null && index2 != null) //both are NOT EMPTY.
		{
			if(index.term.degree == index2.term.degree)
			{
				if(index.term.coeff+index2.term.coeff == 0) //accounts for empty(zero) coefficients.
				{
					//do nothing.
				}
				else
				{
				nPindex = new Node((index.term.coeff)+(index2.term.coeff), index.term.degree, nPindex);
				newPoly.poly = nPindex;
				}
				index = index.next;
				index2 = index2.next;
			}
			else if(index.term.degree > index2.term.degree)
			{	
				if(index2.next == null)
				{
					index2.next = index;
				}
				nPindex = new Node(index2.term.coeff, index2.term.degree, nPindex);
				index2 = index2.next;
				newPoly.poly = nPindex;
			}
			else if(index.term.degree < index2.term.degree)
			{
				if(index.next == null)
				{					
					index.next = index2;
				}
				nPindex = new Node(index.term.coeff, index.term.degree, nPindex);
				index = index.next;
				newPoly.poly = nPindex;
			}
		}
		Node resultList = null;
		Node temp = newPoly.poly;
		while(temp != null){
			resultList = new Node(temp.term.coeff, temp.term.degree, resultList);
			temp = temp.next;
		}
		newPoly.poly = resultList;
//		System.out.println(this);
//		System.out.println(p);
		return newPoly; //Also accounts for both ARE EMPTY.

	}
	
	/**
	 * Returns the polynomial obtained by multiplying the given polynomial p
	 * with this polynomial - DOES NOT change this polynomial
	 * 
	 * @param p Polynomial with which this polynomial is to be multiplied
	 * @return A new polynomial which is the product of this polynomial and p.
	 */
		public Polynomial multiply(Polynomial p) {
			Node index = this.poly;
			Node index2 = p.poly;
			Polynomial polyProduct = new Polynomial();
			
			Node tempNode = null;
			Polynomial tempPoly = new Polynomial();
			
			while(index != null ^ index2 != null) //if first poly is null, OR if second poly is null, but NOT both are null.
			{
				return polyProduct;	//basically return 0.
			}
			
			while(index!=null) //If both polynomials are not null.
			{
				while(index2 != null)
				{
				tempNode = new Node((index.term.coeff * index2.term.coeff),(index.term.degree+index2.term.degree),tempNode);
				tempPoly.poly = tempNode;
				//System.out.println(tempPoly);
				index2 = index2.next;
				}
				polyProduct.poly = null; //resets polyProduct to counteract the properties of the add() method.
//				System.out.println("polyProduct = "+polyProduct);
				polyProduct = polyProduct.add(tempPoly); //temporarily stores the addition of the temporary polynomial and the current.
				index = index.next;
				index2 = p.poly;
			}
			return polyProduct;
		}

//		return polySort(polyProduct);

	
	/**
	 * Evaluates this polynomial at the given value of x
	 * 
	 * @param x Value at which this polynomial is to be evaluated
	 * @return Value of this polynomial at x
	 */
	public float evaluate(float x) {
		float evaluation = 0, currentValue = 0;
		Node curr = this.poly;

		while (curr != null) {

			currentValue = (float)Math.pow(x,curr.term.degree); //does the exponent calculation.
			currentValue *= curr.term.coeff; //does the coefficient calculation.
			
			evaluation += currentValue; //adds to the answer.
			curr = curr.next;
		}
		return evaluation;
	}
	
	/* (non-Javadoc)
	 * @see java.lang.Object#toString()
	 */
	public String toString() {
		String retval;
		
		if (poly == null) {
			return "0";
		} else {
			retval = poly.term.toString();
			for (Node current = poly.next ;
			current != null ;
			current = current.next) {
				retval = current.term.toString() + " + " + retval;
			}
			return retval;
		}
	}
}