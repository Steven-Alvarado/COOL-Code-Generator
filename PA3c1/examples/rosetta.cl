(* 
Steven Alvarado (sra23)

Program takes in a list of dependant tasks form stdin and either outputs
a valid order in which to perform them or the single word 'cycle'
Topological sort using Depth-First Search 
*)

-- tuples of strings
class List {
    a : String ;
    b : String ;
    next : List ;

    init (newa : String, newb : String, newnext : List) : List { {
        a <- newa;
        b <- newb;
        next <- newnext ;
        self ;
    } };

    get_a() : String { a } ;
    get_b() : String { b } ;
    get_next() : List { next };
};

class Main inherits IO {
    --dfs vars
    edges : List ;
    tempMarked : List <- new List;
    permMarked : List <- new List;
    sortedTasks : List <- new List;
    printed : Bool <- false; -- keep track of printed tasks
    allNodes : List <- new List; -- keep track of nodes



    reverse(l : List) : List {
        -- Initialize with empty list node 
        -- to prevent new line on output
        reverse_list(l, new List) 
    };

    -- reverse list to print in correct order
    reverse_list(l : List, acc : List ) : List { {
        if isvoid l then
            acc
        else
            reverse_list(l.get_next(), (new List).init(l.get_a(), "", acc))
        fi;
    } };

    --print list using reverse for desired order
    print(l : List) : Object { { 
        let reversed : List <- reverse(l) in
        if not isvoid reversed then {
            out_string(reversed.get_a());
            reversed <- reversed.get_next();
            while not isvoid reversed loop {
                out_string(reversed.get_a());  
                reversed <- reversed.get_next();
                if not isvoid reversed then -- for proper new line formatting
                    out_string("\n")
                else
                    self
                fi;
            }   pool;
        }
        else
            self
        fi;
    } } ;

    -- find if list contains elm
    contains(l : List, a : String) : Bool { {
        if isvoid l then
            false
        else {
            if l.get_a() = a then
                true 
            else 
                contains(l.get_next(), a)
            fi ;
        } fi ;
    } } ;

    -- function to add node to allNodes
    addNode(n : String) : Object { {
        if not contains(allNodes, n) then
            -- maintain lexicographic order
            allNodes <- insert_sorted(n, "", allNodes)  
        else
            self
        fi;
    } };
   
    -- function to insert a sorted task
    insert_sorted(a : String, b : String, sorted : List) : List { {
        if isvoid sorted then 
            (new List).init(a, b, sorted)
        else {
            if a <= sorted.get_a() then 
            -- Insert before current node
                (new List).init(a, b, sorted)  
            else 
                (new List).init(sorted.get_a(), sorted.get_b(), 
                                insert_sorted(a, b, sorted.get_next()))  
            fi;
        }
        fi;
    } };

(* dfs topological sort implementation

    L ← Empty list that will contain the sorted nodes
    while exists nodes without a permanent mark do
    select an unmarked node n
    visit(n)

    function visit(node n)
    if n has a permanent mark then
        return
    if n has a temporary mark then
        stop   (graph has at least one cycle)

    mark n with a temporary mark

    for each node m with an edge from n to m do
        visit(m)

    mark n with a permanent mark
    add n to head of L
    *)

    dfs(src : String) : Object { {
        -- if already permanent marked then return
        if contains(permMarked, src) then 
            self
        else {
            -- if already temporary marked cycle is also detected
            if contains(tempMarked, src) then{
                if not printed then {
                    out_string("cycle\n");
                    printed <- true;
                }
                else
                    self
                fi;
            }
            else {
                tempMarked <- (new List).init(src, "", tempMarked);
                -- make sure edges is in lexicographic order 
                let edge_ptr : List <- edges  in 
                let dependencies : List <- new List in {

                -- collect dependencies of src
               while not isvoid edge_ptr loop {
                   if edge_ptr.get_a() = src then
                       dependencies <- insert_sorted(edge_ptr.get_b(), "", dependencies)
                   else
                       self
                   fi;
                   edge_ptr <- edge_ptr.get_next();
               } pool;

               -- visit dependencies in sorted order
               while not isvoid dependencies loop {
                   dfs(dependencies.get_a());
                   dependencies <- dependencies.get_next();
               } pool;
            };

                -- permanently mark node
                permMarked <- (new List).init(src, "", permMarked); 
                -- add node to sorted list
                if not contains(sortedTasks, src) then -- only add if not already in list
                    sortedTasks <- (new List).init(src, "", sortedTasks)
                else
                    self
                fi;
            }
            fi;
        } 
        fi;
    } } ;
           
    main() : Object { {
        let reading : Bool <- true in 
        {
            
            while reading loop 
                let a : String <- in_string () in 
                let b : String <- in_string () in 
                if a = "" then
                    reading <- false                 
                else{
                    if b = "" then
                        reading <- false
                    else {
                        edges <- (new List).init(a, b, edges);
                        addNode(a);
                        addNode(b);

                        }
                    fi;
                    }
                fi
            pool;

            -- DFS 
            let node_ptr : List <- allNodes in 

            while not (isvoid node_ptr) loop {
                if not printed then {
                    if not contains(permMarked, node_ptr.get_a()) then
                        dfs(node_ptr.get_a())
                    else
                        self
                    fi; 
                    node_ptr <- node_ptr.get_next();
                }
                else 
                    -- just advance, loop will exit naturally
                    node_ptr <- node_ptr.get_next()  
                fi;
            }
            pool;
            
           if not printed then
                print(sortedTasks)
           else
               self
           fi;
        };
    } };
} ;
