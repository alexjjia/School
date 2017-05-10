package apps;

import java.io.IOException;
import java.util.ArrayList;
import java.util.NoSuchElementException;
import java.util.Scanner;
import java.util.StringTokenizer;

import structures.Stack;

public class Expression {

	/**
	 * Expression to be evaluated
	 */
	String expr;                
    
	/**
	 * Scalar symbols in the expression 
	 */
	ArrayList<ScalarSymbol> scalars;   
	
	/**
	 * Array symbols in the expression
	 */
	ArrayList<ArraySymbol> arrays;
    
	/**
	 * Positions of opening brackets
	 */
	ArrayList<Integer> openingBracketIndex; 
    
	/**
	 * Positions of closing brackets
	 */
	ArrayList<Integer> closingBracketIndex; 

    /**
     * String containing all delimiters (characters other than variables and constants), 
     * to be used with StringTokenizer
     */
    public static final String delims = " \t*+-/()[]";
    
    /**
     * Initializes this Expression object with an input expression. Sets all other
     * fields to null.
     * 
     * @param expr Expression
     */
    public Expression(String expr) {
        this.expr = expr;
        scalars = null;
        arrays = null;
        openingBracketIndex = null;
        closingBracketIndex = null;
    }

    /**
     * Matches parentheses and square brackets. Populates the openingBracketIndex and
     * closingBracketIndex array lists in such a way that closingBracketIndex[i] is
     * the position of the bracket in the expression that closes an opening bracket
     * at position openingBracketIndex[i]. For example, if the expression is:
     * <pre>
     *    (a+(b-c))*(d+A[4])
     * </pre>
     * then the method would return true, and the array lists would be set to:
     * <pre>
     *    openingBracketIndex: [0 3 10 14]
     *    closingBracketIndex: [8 7 17 16]
     * </pre>
     * 
     * See the FAQ in project description for more details.
     * 
     * @return True if brackets are matched correctly, false if not
     */
    public boolean isLegallyMatched() {
    	String str = "";
    	int skipper = 0;
    	Stack<Character> stack = new Stack<Character>();
    	openingBracketIndex = new ArrayList<Integer>();
    	closingBracketIndex = new ArrayList<Integer>();
    	for(int index = 0; index < expr.length(); index++)
    	{
    		if(expr.charAt(index) == '[' || expr.charAt(index) == '(')
    		{
    			openingBracketIndex.add(index);
    			closingBracketIndex.add(0); //placeholder.
    			System.out.println("Opening: "+openingBracketIndex);
    			System.out.println("Closing"+closingBracketIndex);
    			stack.push(expr.charAt(index));
    			str+=expr.charAt(index);
    			System.out.println("str is:"+str);
    			
    			continue;
    			//([()[()]])
    		}
    		else if(expr.charAt(index) == ']' || expr.charAt(index) == ')')
    		{
    			if(stack.isEmpty())
    			{
    				return false; //means that a closing bracket/parenthesis is the first in the expression.
    			}    		
    			//str +=expr.charAt(index);
    			char stackbracket = stack.peek(); 
				if (stackbracket == '(' && expr.charAt(index) == ')') {
					int openParenthesisTracker = openingBracketIndex.indexOf(str.lastIndexOf(stackbracket)); //returns index within openBracketIndex that contains the match we wanna make.
					System.out.println("str is now: "+str);
					System.out.println("openParentTracker: "+openParenthesisTracker);
					closingBracketIndex.set(openParenthesisTracker, index);
					System.out.println("Openingv2:"+openingBracketIndex);
					System.out.println("Closingv2: "+closingBracketIndex);
					stack.pop(); //removes it.
					skipper++;
					//replaces the parenthesis that were found matched, with lovely ^ symbols.
					if(str.length() >=openParenthesisTracker+2)
					{		
						str = str.substring(0,openParenthesisTracker)+"^"+str.substring(openParenthesisTracker+1,str.length()-1)+"^";
					}
					else if(str.length()==openParenthesisTracker+1)
					{
						str = str.substring(0,openParenthesisTracker)+"^"+"^";
					}
					System.out.println("str is NOW: "+str);
					continue;
				}
				else if (stackbracket == '[' && expr.charAt(index) == ']') {
					int openBracketTracker = openingBracketIndex.indexOf(str.lastIndexOf(stackbracket))+skipper; //returns index within openBracketIndex that contains the match we wanna make.
					System.out.println("str is now: "+str);
					System.out.println("openBracketTracker: "+openBracketTracker);
					closingBracketIndex.set(openBracketTracker, index);
					System.out.println("Openingv3:"+openingBracketIndex);
					System.out.println("Closingv3: "+closingBracketIndex);
					stack.pop();
					skipper++;
					if(str.length() >=openBracketTracker+2)
					{		
						str = str.substring(0,openBracketTracker)+"^"+str.substring(openBracketTracker+1)+"^";
						
					}
					else if(str.length()==openBracketTracker+1)
					{
						str = str.substring(0,openBracketTracker)+"^"+"^";
						
					}
					System.out.println("str is NOW: "+str);
					continue;
				}
				return false;
			}
    	}
    	//check if the nth index of openingBracketIndex = the complement of the nth index of the closing BracketIndex,
    	//i.e if the parenthesis or brackets match.
    	System.out.println("Final OpeningBracket: "+openingBracketIndex+"\n Final ClosingBracket: "+closingBracketIndex);
    	return stack.isEmpty(); //would be true
    }

    /**
     * Populates the scalars and arrays lists with symbols for scalar and array
     * variables in the expression. For every variable, a SINGLE symbol is created and stored,
     * even if it appears more than once in the expression.
     * At this time, the constructors for ScalarSymbol and ArraySymbol
     * will initialize values to zero and null, respectively.
     * The actual values will be loaded from a file in the loadSymbolValues method.
     */
    public void buildSymbols() {
    	scalars = new ArrayList<ScalarSymbol>();
		arrays = new ArrayList<ArraySymbol>();
		String operator = "";
		boolean bool = false;

		for (int index = 0; index < expr.length(); index++)
		{
			if (Character.isLetter(expr.charAt(index))) 
			{

				while (index < expr.length() && Character.isLetter(expr.charAt(index))){
					operator += expr.charAt(index);
					index++;
				}
				if (index < expr.length() && expr.charAt(index) == '['){
					bool = true;}
				if (bool == true) {
					ArraySymbol symbolArray = new ArraySymbol(operator);
					arrays.add(symbolArray);
				} else {
					ScalarSymbol scalarArray = new ScalarSymbol(operator);
					scalars.add(scalarArray);
				}
			}
		}

    } 
    
    /**
     * Loads values for symbols in the expression
     * 
     * @param sc Scanner for values input
     * @throws IOException If there is a problem with the input 
     */
    public void loadSymbolValues(Scanner sc) 
    throws IOException {
        while (sc.hasNextLine()) {
            StringTokenizer st = new StringTokenizer(sc.nextLine().trim());
            int numTokens = st.countTokens();
            String sym = st.nextToken();
            ScalarSymbol ssymbol = new ScalarSymbol(sym);
            ArraySymbol asymbol = new ArraySymbol(sym);
            int ssi = scalars.indexOf(ssymbol);
            int asi = arrays.indexOf(asymbol);
            if (ssi == -1 && asi == -1) {
            	continue;
            }
            int num = Integer.parseInt(st.nextToken());
            if (numTokens == 2) { // scalar symbol
                scalars.get(ssi).value = num;
            } else { // array symbol
            	asymbol = arrays.get(asi);
            	asymbol.values = new int[num];
                // following are (index,val) pairs
                while (st.hasMoreTokens()) {
                    String tok = st.nextToken();
                    StringTokenizer stt = new StringTokenizer(tok," (,)");
                    int index = Integer.parseInt(stt.nextToken());
                    int val = Integer.parseInt(stt.nextToken());
                    asymbol.values[index] = val;              
                }
            }
        }
    }
    
    /**
     * Evaluates the expression, using RECURSION to evaluate subexpressions and to evaluate array 
     * subscript expressions. (Note: you can use one or more private helper methods
     * to implement the recursion.)
     * 
     * @return Result of evaluation
     */
    public float evaluate() {
    	return 0;
    }

    /**
     * Utility method, prints the symbols in the scalars list
     */
    public void printScalars() {
        for (ScalarSymbol ss: scalars) {
            System.out.println(ss);
        }
    }
    
    /**
     * Utility method, prints the symbols in the arrays list
     */
    public void printArrays() {
    	for (ArraySymbol as: arrays) {
    		System.out.println(as);
    	}
    }

}