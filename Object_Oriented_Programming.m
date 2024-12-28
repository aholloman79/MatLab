
%% 
% Object-Oriented Programming 

% This script demonstrates the use of Object-Oriented Programming (OOP) in MATLAB. 
% The concepts include value vs handle classes, constructors, inheritance, and abstract classes.

%% Step 1: Value vs Handle Classes
% In MATLAB, classes are divided into two categories:
% - **Value Classes**: Copy the data when creating a new instance.
% - **Handle Classes**: Share data between instances.

% Define a value class
classdef valueClass
    properties
        data % I used this to store class-specific data that doesn't need to be shared.
    end
end

% Define a handle class
classdef handleClass < handle
    properties
        data % I used this to store shared data that updates across instances.
    end
end

% Example usage
v1 = valueClass; % Create a value class instance
v1.data = 5; % Set the data property of the instance
v2 = v1; % Create a new instance by copying v1
v2.data = 7; % Update the data in v2

disp(v1.data); % Value classes remain independent
disp(v2.data);

h1 = handleClass; % Create a handle class instance
h1.data = 5; % Set the data property of the handle class instance
h2 = h1; % Create a new instance pointing to the same data
h2.data = 7; % Update the shared data
disp(h1.data); % Handle classes share data
disp(h2.data);

%% Step 2: Constructors
% A constructor is a special method that initializes an object. MATLAB automatically creates
% a default constructor if none is defined. Below is an example of creating a constructor.

classdef Person
    properties
        name % I used this to store the first name of the person.
        surname % I used this to store the last name.
        address % This property holds the person's address.
    end
    
    methods
        function obj = Person(name, surname, address)
            % Constructor to initialize the Person object.
            obj.name = name;
            obj.surname = surname;
            obj.address = address;
        end
    end
end

% Example usage of the Person class
p = Person('John', 'Smith', 'London'); % Creating a new instance
disp(p); % Display the object details

%% Step 3: Inheritance and Constructors
% MATLAB supports inheritance to share common functionality across classes.

classdef Member < Person
    properties
        payment % I added this to store payment details specific to members.
    end
    
    methods
        function obj = Member(name, surname, address, payment)
            % Calling the parent class constructor
            obj = obj@Person(name, surname, address); 
            obj.payment = payment; % Initialize the payment property
        end
    end
end

% Example usage of the Member class
m = Member('Adam', 'Woodcock', 'Manchester', 20); % Creating a new instance
disp(m); % Display the object details

%% Step 4: Abstract Classes and Logging Example
% Abstract classes provide a common interface for multiple subclasses.

% Abstract class
classdef MessageLogger
    methods(Abstract)
        LogMessage(obj, varargin) % Define an abstract method
    end
end

% Concrete class to log messages to the screen
classdef ScreenLogger < MessageLogger
    properties(Access = protected)
        scrh % I used this to store the screen handler.
    end
    
    methods
        function obj = ScreenLogger(screenhandler)
            obj.scrh = screenhandler; % Initialize the screen handler
        end
        
        function LogMessage(obj, varargin)
            if ~isempty(varargin)
                varargin{1} = num2str(varargin{1});
                fprintf(obj.scrh, '%s\n', sprintf(varargin{:})); % Print message to the screen
            end
        end
    end
end

% Concrete class to log messages to a file
classdef DeepLogger < MessageLogger
    properties
        FileName % I used this to store the log file name.
    end
    
    methods
        function obj = DeepLogger(filename)
            obj.FileName = filename; % Initialize the log file name
        end
        
        function LogMessage(obj, varargin)
            if ~isempty(varargin)
                varargin{1} = num2str(varargin{1});
                fid = fopen(obj.FileName, 'a'); % Open file in append mode
                fprintf(fid, '%s\n', sprintf(varargin{:})); % Write the message to the file
                fclose(fid); % Close the file
            end
        end
    end
end

% Example usage of loggers
logger = ScreenLogger(1); % Create a ScreenLogger
logger.LogMessage('This is a message logged to the screen.'); % Log a message to the screen

fileLogger = DeepLogger('logfile.txt'); % Create a DeepLogger
fileLogger.LogMessage('This is a message logged to a file.'); % Log a message to the file

%% Step 5: Combining Loggers
% A logger that combines screen and file logging.

classdef CombinedLogger < ScreenLogger
    properties
        FileLogger % I added this to include the DeepLogger as a property.
    end
    
    methods
        function obj = CombinedLogger(screenhandler, filename)
            obj@ScreenLogger(screenhandler); % Initialize the parent class
            obj.FileLogger = DeepLogger(filename); % Initialize the file logger
        end
        
        function LogMessage(obj, varargin)
            LogMessage@ScreenLogger(obj, varargin{:}); % Log to the screen
            obj.FileLogger.LogMessage(varargin{:}); % Log to the file
        end
    end
end

% Example usage of CombinedLogger
combinedLogger = CombinedLogger(1, 'combined_log.txt'); % Create a CombinedLogger
combinedLogger.LogMessage('This message is logged to both the screen and the file.');

%% Conclusion
% This live script demonstrated Object-Oriented Programming in MATLAB with examples of value vs handle classes,
% constructors, inheritance, and abstract classes, focusing on logging functionality.