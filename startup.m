function startup()
    
    % add current directory to paths
    p = genpath(pwd); addpath(p);
    ORIG_PATH = path;

    % create folders
    mkdir_fun('data');
    mkdir_fun('diaries');
    mkdir_fun('temp');
 end

function created = mkdir_fun(path_in)
    created = false;
    if exist(path_in, 'dir') == 0
        mkdir(path_in);
        created = true;
    end
end
