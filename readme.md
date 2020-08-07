# Train
It is a repo to record my training.

<!---start--->
[708](#708)
<!---end--->



## 708

###  思路
循环升序链表插入不难，找到最小值/最大值所在的点，就可以分情况讨论插入了。
- 如果插入的值比最大值还大，则插入到下一位
- 否则，找到第一个比它大的node，插入在该node前面

思路很简单，但是需要注意一点，升序是可以重复的。因此需要注意不能循环遍历
```
[3,3,3]
0

[3,3,5]
0
```


### code
```
/*
// Definition for a Node.
class Node {
public:
    int val;
    Node* next;

    Node() {}

    Node(int _val) {
        val = _val;
        next = NULL;
    }

    Node(int _val, Node* _next) {
        val = _val;
        next = _next;
    }
};
*/

class Solution {
public:

    Node *findMax(Node *head) 
    {
        Node* start = head;
        while (head->val <= head->next->val && head->next != start) {
            head = head->next;
        }

        return head;
    }

    void insertToNodesNext(Node *cur, int val)
    {
        Node* n = new Node(val);
        n->next = cur->next;
        cur->next = n;
    }

    void insertFunc(Node *cur, int insertVal)
    {
        // 如果是最大的数插入，直接插入在max的下一位
        if (insertVal >= cur->val) {
            return insertToNodesNext(cur, insertVal);
        }

        // 如果不是，则在循环列表里找到第一次小于的数字插入即可
        while (true) {
            if (cur->next->val >= insertVal) {
                return insertToNodesNext(cur, insertVal);
            }
            cur = cur->next;
        }
    }

    Node* insert(Node* head, int insertVal) {
        if (!head) {
            Node *ans = new Node(insertVal);
            ans->next = ans;
            return ans;
        }

        Node* maxNode = findMax(head); 
        insertFunc(maxNode, insertVal);
        return head;
    }
};
```
