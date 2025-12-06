# Michael Masenheimer
# CSC 252 
# ASIM  4- advanced functions
# Purpose: This MIPS helps give me practice with implementing functions,
# but in a more c-oriented way, involving structs.
# The code implements a bunch of common binary search tree
# methods including, search, init, add, traverse, and count

.data

newline:       .asciiz "\n"

.text

.globl bst_init_node
.globl bst_search
.globl bst_count
.globl bst_in_order_traversal
.globl bst_pre_order_traversal
.globl bst_insert

# FUNCTION 1: bst_init_node(BSTNode *node, int key)

# strlen() {
#	node->key = key
#	node->left = NULL
#	node->right = NULL
# }
# 
# REGISTERS:
# $a0: the BSTNode struct
# $a1: an integer for the key

bst_init_node:

	sw $a1, 0($a0)		# node->key = key
	sw $zero, 4($a0)	# node->left = NULL 
	sw $zero, 8($a0)	# node-> right = NULL

# FUNCTION 2: SEARCH BST

# *bst_search(BSTNode *node, int key) {
#
#	BSTNode *cur = node;
#
#	while (cur != NULL ) {
#	 if (cur -> key == key)
#		return cur;
#	 if (key < cur -> key)
#		cur = cur -> left;
#	 else
#		cur = cur->right;
#	return NULL
# }
#
# REGISTERS:
# $a0 is the input BSTNode
# $a1 is a key (or taget to search for)
# $t0 is a cur tracker for which node we're pointing to
# Various other $tX registers for comparison

bst_search:
	add $t0, $a0, $zero		# BSTNode *cur = node

	LOOP_BSTSEARCH:

		beq $t0, $zero, AFTER_LOOP_BSTSEARCH	# while (cur != null)

		lw $t1, 0($t0)				# $t1 = curr-> key
		beq $a1, $t1, AFTER_LOOP_BSTSEARCH_SUCCESS

		slt $t2, $a1, $t1			# $t2 = key < cur->key
		beq $zero, $t2,	RIGHTSIDE		# if key < cur->key, branch

		lw $t0, 4($t0)				# cur = cur-> left
		j LOOP_BSTSEARCH

		RIGHTSIDE:
		lw $t0, 8($t0)				# cur = cur-> right
		j LOOP_BSTSEARCH

	AFTER_LOOP_BSTSEARCH:
	add $v0, $zero, $zero		# Return NULL
	jr $ra

	AFTER_LOOP_BSTSEARCH_SUCCESS:
	add $v0, $t0, $zero		# Return cur (which is a BSTNode struct)
	jr $ra

# FUNCTION 3: COUNT BST

# int bst_count(BSTNode *node) {
#	if (node == NULL)
#		return 0;
#	return bst_count(node->left) + 1 + bst_count(node->right)
# }
#
# REGISTERS:
# $t0 holds the current node
# $t1 holds the left node
# $t2 holds the right node
# v0, a0 hold return value and parameters, respectively
# Various $tX registers for comparison

bst_count:
	beq $a0, $zero, BASE_CASE_COUNT	# If node == NULL

	add $t0, $a0, $zero		# $t0 = node
	lw $t1, 4($t0)			# $t1 = node->left
	lw $t2, 8($t0)			# $t2 = node->right

	addi $sp, $sp, -12		# Allocate 12 bytes for the node struct
	sw $ra, 8($sp)			# Save return address
	sw $a0, 4($sp)			# Save the struct node
	sw $t2, 0($sp)			# Save node->right

	add $a0, $t1, $zero		# Call bst_count(node->left)
	jal bst_count
	add $t3, $v0, $zero		# Save left count into $t3
	
	lw $t2, 0($sp)			# Save node->right
	lw $a0, 4($sp)			# Load the struct node
    	lw $ra, 8($sp)			# Load return address
    	addi $sp, $sp, 12		# Restore 8 bytes back onto the stack
	
	addi $t3, $t3, 1		# left count += 1
	
	addi $sp, $sp, -12		# Allocate 12 bytes for the node struct
	sw $ra, 8($sp)			# Save return address
	sw $a0, 4($sp)			# Save the struct node
	sw $t3, 0($sp)			# Save the left count + 1
	
	add $a0, $t2, $zero		# Call bst_count(node->right)
	jal bst_count
	add $t4, $v0, $zero		# Save right count into $t4
	
	lw $t3, 0($sp)            	# Restore left count + 1
	lw $a0, 4($sp)			# Load the struct node
    	lw $ra, 8($sp)			# Load return address
    	addi $sp, $sp, 12		# Restore 12 bytes back onto the stack
	
	add $v0, $t3, $t4		# left total + 1 + right total
	jr $ra
	
	BASE_CASE_COUNT:
		add $v0, $zero, $zero 		# Return 0 if the node is null
		jr $ra
	
# FUNCTION 4: IN ORDER TREE TRAVERSAL
#
# void bst_in_order_traversal(BSTNode *node) {
#	if (node == NULL):
#		return;
#
#	bst_in_order_traversal(node->left);
#	printf("%d\n", node->key);
#	bst_in_order_traversal(node->right);
# }
#
# REGISTERS:
# $t0: the whole c struct(node)
# $t1: the node key
# $t2: left node
# $t3 : right node

bst_in_order_traversal:

	beq $a0, $zero, BASE_CASE_IN_ORDER

	add $t0, $a0, $zero		# $t0 = node
	lw $t1, 0($t0)			# $t1 = node->key
	lw $t2, 4($t0)			# $t2 = node->left
	lw $t3, 8($t0)			# $t3 = node->right

	addi $sp, $sp, -16		# Allocate 12 bytes for the node struct
	sw $ra, 12($sp)			# Save return address
	sw $t1, 8($sp)			# Save the key
	sw $t2, 4($sp)			# Save the left node
	sw $t3, 0($sp)			# Save the right node
	
	add $a0, $t2, $zero		# Recurse on (node->left)
	jal bst_in_order_traversal
	
	lw $t3, 0($sp)			# Load the right node
	lw $t1, 8($sp)			# Load the key

    	addi $v0, $zero, 1		# Print_int(node->key)
	add $a0, $t1, $zero
	syscall

	addi $v0, $zero, 4		# print_str("\n")
	la $a0, newline			
	syscall

	lw $t3, 0($sp)			# Restore node->right
	add $a0, $t3, $zero		# Recurse on (node->right)
	jal bst_in_order_traversal
	
	lw $ra, 12($sp)			# Load the return address
	addi $sp, $sp, 16		# Restore 16 bytes back
    	
	BASE_CASE_IN_ORDER:
		jr $ra			# End the function

# FUNCTION 5: PRE ORDER TREE TRAVERSAL
#
# void bst_pre_order_traversal(BSTNode *node) {
#	if (node == NULL):
#		return;
#
#	printf("%d\n", node->key);
#	bst_in_order_traversal(node->left);
#	bst_in_order_traversal(node->right);
# }
#
# REGISTERS:
# $t0: the whole c struct(node)
# $t1: the node key
# $t2: left node
# $t3 : right node

bst_pre_order_traversal:
	
	beq $a0, $zero, BASE_CASE_PRE_ORDER
	
	add $t0, $a0, $zero		# $t0 = node
	lw $t1, 0($t0)			# $t1 = node->key
	lw $t2, 4($t0)			# $t2 = node->left
	lw $t3, 8($t0)			# $t3 = node->right

	addi $v0, $zero, 1		# Print_int(node->key)
	add $a0, $t1, $zero		# Print the key
	syscall
	
	addi $v0, $zero, 4		# print_str("\n")
	la $a0, newline			# Print the newline
	syscall
	
	addi $sp, $sp, -16		# Allocate 12 bytes for the node struct
	sw $ra, 12($sp)			# Save return register
	sw $t1, 8($sp)			# Save the key
	sw $t2, 4($sp)			# Save the left node
	sw $t3, 0($sp)			# Save the right node
	
	add $a0, $t2, $zero		# Recurse on (node->left)
	jal bst_pre_order_traversal
	
	lw $t3, 0($sp)			# Load the right node
	lw $t1, 8($sp)			# Load the key
	
	lw $t3, 0($sp)			# Restore node->right (because of syscall)
	add $a0, $t3, $zero		# Recurse on (node->right)
	jal bst_pre_order_traversal
	
	lw $ra, 12($sp)			# Load the return address
	addi $sp, $sp, 16		# Restore 16 bytes back
    	
	BASE_CASE_PRE_ORDER:
		jr $ra			# End the function (base case hit)

# FUNCTION 6: INSERT BST NODE

# BSTNode *bst_insert(BSTNode *root, BSTNode *newNode) {
#	if (root == NULL):
#		return newNode;
#	if (newNode->key < root->key):
#		root->left = bst_insert(root->left, newNode);
#	else:
#		root->right = bst_insert(root->right, newNode);
#	return root;
# }
#
# REGISTERS:
# $t0 is the root of the old tree
# $t1 is the key of the old tree's root
# $t2 is the left child of the root
# $t3 is the right child of the root
# $t4 is the new node itself
# $t5 is the key of the newnode
# $v0 is the return register for recursion
# $a0 is the the root struct parameter
# $a1 is the struct of the new node to be added

bst_insert:

	beq $a0, $zero, BASE_CASE_INSERT	# if root == NULL, return newNode

	add $t0, $a0, $zero			# $t0 = root
	lw $t1, 0($t0)				# $t1 = root->key
	lw $t2, 4($t0)				# $t2 = root->left
	lw $t3, 8($t0)				# $t3 = root->right
	
	add $t4, $a1, $zero			# $t4 = newnode
	lw $t5, 0($t4)				# $t5 = newnode->key
	
	slt $t9, $t5, $t1			# newNode->key < root->key
	beq $t9, $zero, RIGHT_INSERT		# if newNode->key < root->key, recurse on the right
	
	# Recurse on the left child
	addi $sp, $sp, -12		# Allocate 12 bytes for the node struct
	sw $ra, 8($sp)			# Save return register
	sw $a0, 4($sp)			# Save root pointer
	sw $a1, 0($sp)			# Save newNode pointer
	
	add $a0, $t2, $zero		# Call bst_insert(root->left) (1st parameter)
	jal bst_insert
	
	lw $a1, 0($sp)			# Restore newNode
	lw $a0, 4($sp)			# Restore root
    	lw $ra, 8($sp)			# Load return address
    	addi $sp, $sp, 12		# Restore 12 bytes back onto the stack
    	
    	sw $v0, 4($a0)			# root->left = return val from recursion
    	add $v0, $a0, $zero		# Return root
    	jr $ra

	RIGHT_INSERT:
	# Recurse on the right child
	
	addi $sp, $sp, -12		# Allocate 12 bytes for the node struct
	sw $ra, 8($sp)			# Save return address
	sw $a0, 4($sp)			# Save root pointer
	sw $a1, 0($sp)			# Save newNode pointer
	
	add $a0, $t3, $zero		# Call bst_insert(root->left) (1st parameter)
	jal bst_insert
	
	lw $a1, 0($sp)			# Restore newNode
	lw $a0, 4($sp)			# Restore root
    	lw $ra, 8($sp)			# Load return address
    	addi $sp, $sp, 12		# Restore 12 bytes back onto the stack
    	
    	sw $v0, 8($a0)			# root->right return val from recursion
    	add $v0, $a0, $zero		# Return root
    	jr $ra
	
	BASE_CASE_INSERT:
		add $v0, $a1, $zero	# Return newNode
		jr $ra