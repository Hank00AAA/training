# Train
It is a repo to record my training.

<!---start--->
[4](#4)  
[708](#708)  
[5483](#5483)  
[5484](#5484)  
[5471](#5471)  
[5486](#5486)  
[173](#173)  
[459](#459)  
[3](#3)  
<!---end--->

## 4
### 中位数
两种做法，
1. 利用割的思想。
123 | 456
123 | 456 
条件：
1. cut1 + cut2 = (arr.size() + 1) / 2
2. maxLeft(cut1) < minRight(cut2)
3. maxLeft(cut2) < minRight(cut1)

2. 利用求第k个小的数字

### code 
```
// cut
class Solution {
public:
    double findMedianSortedArrays(vector<int>& nums1, vector<int>& nums2) {
        if (nums1.size() > nums2.size()) return findMedianSortedArrays(nums2, nums1);
        int l = 0, r = nums1.size();
        int L1, L2, R1, R2, cut1, cut2;
        int len = (nums1.size() + nums2.size());
        
        while (l <= r) {
            cut1 = l + (r - l) / 2;
            cut2 = (len + 1) / 2 - cut1;
            L1 = cut1 == 0 ? INT_MIN : nums1[cut1 - 1];
            R1 = cut1 >= nums1.size() ? INT_MAX : nums1[cut1];
            L2 = cut2 == 0 ? INT_MIN : nums2[cut2 - 1];
            R2 = cut2 >= nums2.size() ? INT_MAX : nums2[cut2];

            if (L1 > R2) {
                r = cut1 - 1;
                continue;
            }

            if (L2 > R1) {
                l = cut1 + 1;
                continue;
            }

            break;
        }

        double res;
        if (len % 2 == 1) {
            res = max(L1, L2);
        } else {
            res = (max(L1, L2) + min(R1, R2)) / 2.0;
        }

        return res;
    }
};
```

```
// k
class Solution {
public:
    double findMedianSortedArrays(vector<int>& nums1, vector<int>& nums2) {
        int len = nums1.size() + nums2.size();
        if (len % 2 == 1) {
            return findK(nums1, nums2, (len + 1) / 2);
        } else {
            return (findK(nums1, nums2, (len + 1) / 2) + findK(nums1, nums2, (len + 1) / 2 + 1)) / 2.0;
        }
    }

    int findK(vector<int>& nums1, vector<int>& nums2, int k) {
        int s1 = 0, s2 = 0;
        int l1, l2;
        
        while (s1 < nums1.size() && s2 < nums2.size()) {
            if (k == 1) {
                break;
            }

            l1 = min(s1 + k / 2 - 1, int(nums1.size() - 1));
            l2 = min(s2 + k / 2 - 1, int(nums2.size() - 1));
            if (nums1[l1] < nums2[l2]) {
                k -= l1 - s1 + 1;
                s1 = l1 + 1;
            } else {
                k -= l2 - s2 + 1;
                s2 = l2 + 1;
            }
        }
        
        if (s1 >= nums1.size()) {
            return nums2[s2 + k - 1];
        }

        if (s2 >= nums2.size()) {
            return nums1[s1 + k - 1];
        }
        
        return min(nums1[s1], nums2[s2]);
    }

};
```


## 3
### 思路
记录下标，O(n)

### code
```
class Solution {
public:
    int lengthOfLongestSubstring(string s) {
        vector<int> c;
        c.resize(256, -1);
        int last = -1;
        int maxLen = 0;

        for (int i = 0; i < s.size(); ++i) {
            last = max(last, c[s[i]]);
            c[s[i]] = i;
            maxLen = max(maxLen, i - last);
        }

        return maxLen;
    }
};
```

## 459
### 思路
这道题就是周期串，看到有个解答挺厉害的，s + s，然后就是计算s在(s+s)串中第二次出现的位置，如果是周期串，那么第二次出现的位置必定不为s.len

### code
```
class Solution {
public:

    bool check(string &s, int len)
    {
        if (s.size() % len) {
            return false;
        }

        int start = 0;
        int i = 0;
        while (i < s.size()) {
            if (start >= len) {
                start = 0;
            }

            if (s[i] != s[start]) {
                return false;
            }
            ++i;
            ++start;
        }

        return true;
    }

    bool repeatedSubstringPattern(string s) {
        int len = 1;

        if (s.empty()) {
            return false;
        }

        while (len <= s.size() / 2) {
            if (check(s, len)) {
                return true;
            }
            ++len;
        }

        return false;
    }
};
```

## 173
### 思路
二叉树迭代器，这道题其实就是把栈存起来，参考二叉树中序遍历的非递归实现。

### code
```
/**
 * Definition for a binary tree node.
 * struct TreeNode {
 *     int val;
 *     TreeNode *left;
 *     TreeNode *right;
 *     TreeNode(int x) : val(x), left(NULL), right(NULL) {}
 * };
 */
class BSTIterator {
public:
    vector<TreeNode *> v;
    bool flag;

    BSTIterator(TreeNode* root) {
        if (!root) {
            return;
        }
        
        v.push_back(root);
        flag = false;
    }
    
    /** @return the next smallest number */
    int next() {
        TreeNode *cur = v.back();

        while (!flag && cur->left) {
            v.push_back(cur->left);
            cur = cur->left;
        }
        flag = true;
        v.pop_back();
        if (cur->right) {
            v.push_back(cur->right);
            flag = false;
        }
        
        return cur->val;        
    }
    
    /** @return whether we have a next smallest number */
    bool hasNext() {
        return !v.empty();
    }
};

/**
 * Your BSTIterator object will be instantiated and called as such:
 * BSTIterator* obj = new BSTIterator(root);
 * int param_1 = obj->next();
 * bool param_2 = obj->hasNext();
 */
```

## 5486
### 思路
这道题是动态规划，设dp[l][r]是从[l, r]的切割最小成本，dp[l][r] = min(l到r之间所有切割点i,dp[l][i] + dp[i][r]) + r - l;

###  code
```
class Solution {
public:

    vector<vector<int>> dp;

    int dfs(int l, int r, vector<int> &v)
    {
        if (dp[l][r] != -1) {
            return dp[l][r];
        }

        if (l + 1 == r) {
            dp[l + 1][r] = 0;
            return 0; 
        }

        for (int i = l + 1; i < r; ++i) {
            int t = dfs(l, i, v) + dfs(i, r, v) + v[r] - v[l];
            if (dp[l][r] == -1 || dp[l][r] > t) {
                dp[l][r] = t;
            }
        }

        return dp[l][r];
    }

    int minCost(int n, vector<int>& cuts) {
        dp.resize(103, vector<int>(103, -1));
        cuts.push_back(0);
        cuts.push_back(n);
        sort(cuts.begin(), cuts.end());
        return dfs(0, cuts.size() - 1, cuts);
    }
};
```

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
