/*

You are given a table, BST, containing two columns: N and P, where N
represents the value of a node in Binary Tree, and P is the parent of N.

Write a query to find the node type of Binary Tree ordered by the value of
the node. 

Output one of the following for each node:

    Root: If node is root node.
    Leaf: If node is leaf node.
    Inner: If node is neither root nor leaf node.

*/
SELECT CONVERT(VARCHAR, T1.N) + ' ' + 
       CASE 
        WHEN T1.P IS NULL THEN 'Root'
        WHEN T1.P IS NOT NULL AND PARENT.P IS NULL THEN 'Leaf'
        ELSE 'Inner' END
FROM BST T1
OUTER APPLY 
( SELECT TOP 1 T2.P 
   FROM BST T2
  WHERE T2.P = T1.N
  ORDER BY T2.P
) PARENT
ORDER BY T1.N

/*

SELECT n,
	CASE
		WHEN p IS NULL THEN 'Root'
		WHEN EXISTS (SELECT 1 FROM BST in_bst WHERE in_bst.P = out_bst.N) THEN 'Inner'
		ELSE 'Leaf'
	END
FROM BST out_bst
ORDER BY n;

SELECT n,
	CASE
		WHEN p IS NULL THEN 'Root'
		WHEN ((SELECT COUNT(*) FROM bst in_bst WHERE in_bst.p = out_bst.n) > 0) THEN 'Inner'
		ELSE 'Leaf'
	END
FROM bst out_bst
ORDER BY n;

*/
