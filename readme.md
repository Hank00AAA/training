# Train
It is a repo to record my training.

<!---start--->
[5471](#5471) 
[708](#708) 
[5483](#5483) 
[5484](#5484) 
<!---end--->

## 5471
### 思路
这道题和当时面试微软的题目差不多，一直计算sum[0,i]， 然后用map存下每个sum的结果，查询是否有等于sum-target的前缀数组。因为题目说了不重复，所以这里需要用贪心算法，如有sum[0, 3] sum[2, 5]都等于10，
那么我们只需要存下m[5]=10，因为这样 i - m[5]的子数组是最短的。然后再判断当前取到数组的最大下标是否和当前数组重叠了，如果没重叠，显然可以取，如果重叠了，我们取idx最小的，即丢弃当前idx，继续往下计算即可。
还需要注意一点，m[0] = -1，因为当sum == target时，需要m[0] = -1来指示当前子数组可用。
为什么m[0]不能初始化为0？ 考虑[3,0,0] 3的情况，会m[0] = 0会导致重复计算

### 代码
```
class Solution {
public:
    int maxNonOverlapping(vector<int>& nums, int target) {
        map<int, int> m;
        int sum = 0;
        int t;
        int ans = 0;
        int curMinIdx = -1;
        
        if (nums.empty()) {
            return 0;
        }
        
        m[0] = -1;
        for (int i = 0; i < nums.size(); ++i) {
            sum += nums[i];
            t = sum - target;
            if (m.find(t) != m.end()) {
                if (curMinIdx <= m[t]) {
                    curMinIdx = i;
                    ++ans;
                    cout<<i<<endl;
                }
            }
            m[sum] = i;
        }
        
        return ans;   
    }
};
```

## 5484
### 思路
这道题数量很大，需要不断转换， 转换到比较小的情况。
k in [1, 2^20 - 1]
mid = 2 ^ N
k = 2 * mid - k
需要处理k恰好是分割点的情况

### 代码
```
const bool s2[3] = {false, true, true};

class Solution {
public:
    int pow2(int n)
    {
        int ans = 1;
        while (n) {
            ans *= 2;
            --n;
        }
        return ans;
    }
    
    int getMinN(int k)
    {
        int cur = 1;
        int mul = 1;
        
        while (mul < k) {
            mul = 2 * mul + 1;
            ++cur;
        }
        
        return cur;
    }
    
    char findKthBit(int n, int k) {
        bool r = false;
        int mid;
        int t;
        
        n = getMinN(k);
        while (n > 2) {
            mid = pow2(n - 1);
            k = 2 * mid - k;
            r = !r;
            if (k == mid) {
                return r + '0';
            }
            t = getMinN(k); 
            n = min(n - 1, t);
        }
        
        if (n == '1') {
            return '0';
        }
        
        return (r ? !s2[k - 1] : s2[k - 1])  + '0';
    }
};
```


---------
## 5483
### 思路
整理字符串，注意一点就是，需要"递归"执行到没有字符串的时候。

### 代码
```
const int lowToUp = 'A' - 'a';

class Solution {
public:
    
    int abs(int x)
    {
        return x > 0 ? x : -x;
    }
    
    bool valid(char a, char b)
    {
        return abs(a - b) == abs(lowToUp);
    }
    
    string makeGood(string s) {
        string ans;
        int i = 0;
        
        while (i < s.size())  {
            ans.push_back(s[i++]);
            while (ans.size() >= 2 && valid(ans.back(), ans[ans.size() - 2])) {
                ans.pop_back();
                ans.pop_back();
            }
        }

        return ans;   
    }
};
```
-----------
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
