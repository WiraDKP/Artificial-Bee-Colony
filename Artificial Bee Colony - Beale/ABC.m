function [bestbee, mincost] = ABC(problem, nvar, bound, param)
    
    func = problem;
    varsize = [1 nvar]; 
    
    itermax = param.itermax;
    npop = param.npop;

    xmin = bound.xmin;
    xmax = bound.xmax;
    a = bound.acc;
    
    lim = round(nvar*npop);
    
    globest.cost = inf;
    
    init.loc = [];
    init.cost = [];

    bee = repmat(init, npop, 1);

    % Scout Bees initiate Food Source
    for i = 1:npop
        bee(i).loc = unifrnd(xmin, xmax, varsize);
        bee(i).cost = func(bee(i).loc);

        if bee(i).cost < globest.cost
            globest = bee(i);
        end
    end

    C = zeros(npop,1);
    bestcost = zeros(itermax,1);
    
    tempEBX = zeros(itermax,npop);
    tempEBY = zeros(itermax,npop);
    tempOBX = zeros(itermax,npop);
    tempOBY = zeros(itermax,npop);
    tempSBX = zeros(itermax,npop);
    tempSBY = zeros(itermax,npop);
    scout = [];
    
    for iter = 1:itermax
        [X,Y] = meshgrid(xmin:0.1:xmax, xmin:0.1:xmax);
        contour(X,Y,log((1.5 - X + X.*Y).^2 + (2.25 - X + X.*Y.^2).^2 + (2.625 - X + X.*Y.^3).^2), 15); hold on;
        scatter(3,0.5,35,'ok','filled');
        title('Beale Function');
        
        % Employed Bees
        for i = 1:npop
            K = [1:i-1 i+1:npop];
            k = K(randi([1 length(K)]));
            
            phi = a*unifrnd(-1,1,varsize);
            
            newbee.loc = min(max(bee(i).loc + phi.*(bee(i).loc-bee(k).loc), xmin),xmax);
            newbee.cost = func(newbee.loc);
            
            if newbee.cost < bee(i).cost
                bee(i) = newbee;
            else
                C(i) = C(i) + 1;
            end
            tempEBX(iter,i) = bee(i).loc(1);
            tempEBY(iter,i) = bee(i).loc(2);
        end

        % Plot Employed Bees
        scatter(tempEBX(iter,:),tempEBY(iter,:),'xb');
        if (iter > 1)
            for i = 1:npop              
                line([tempSBX(iter-1,i);tempEBX(iter,i)],[tempSBY(iter-1,i);tempEBY(iter,i)],'Color','b');
            end
        end
        frame(3*iter-2) = getframe(gcf); pause(0.0001);
        
        % Onlooker Bees
        F = zeros(npop,1);
        for i = 1:npop
            if (bee(i).cost >= 0)
                F(i) = 1/(1+bee(i).cost);
            else
                F(i) = 1+abs(bee(i).cost);                
            end
        end
        P = F/sum(F);

        for j = 1:npop
            i=find(rand<=cumsum(P),1,'first');
            K = [1:i-1 i+1:npop];
            k = K(randi([1 length(K)]));
            
            phi = a*unifrnd(-1,1,varsize);
            
            newbee.loc = min(max(bee(j).loc + phi.*(bee(j).loc-bee(k).loc), xmin),xmax);
            newbee.cost = func(newbee.loc);
            
            if newbee.cost < bee(j).cost
                bee(j) = newbee;
            else
                C(j) = C(j) + 1;
            end
            tempOBX(iter,j) = bee(j).loc(1);
            tempOBY(iter,j) = bee(j).loc(2);
        end
        
        % Plot Onlooker Bees
        scatter(tempOBX(iter,:),tempOBY(iter,:),'xr');
        for i = 1:npop
            line([tempEBX(iter,i);tempOBX(iter,i)],[tempEBY(iter,i);tempOBY(iter,i)],'Color','r', 'LineStyle', '--');
        end
        frame(3*iter-1) = getframe(gcf); pause(0.0001);        
        
        % Scout Bees
        for i = 1:npop
            if C(i) >= lim
                scout = [scout ; i];
                bee(i).loc = unifrnd(xmin,xmax,nvar);
                bee(i).cost = func(bee(i).loc);
                C(i) = 0;
            end
            tempSBX(iter,i) = bee(i).loc(1);
            tempSBY(iter,i) = bee(i).loc(2);
        end
        
        % Plot Scout Bees
        scatter(tempSBX(iter,scout),tempSBY(iter,scout),'ok','filled');       
        for i = 1:length(scout)
            line([tempOBX(iter,scout(i));tempSBX(iter,scout(i))],[tempOBY(iter,scout(i));tempSBY(iter,scout(i))],'Color','k', 'LineWidth', 2);
        end
        scout = []; 
        frame(3*iter) = getframe(gcf); pause(0.0001);
        
        for i = 1:npop
            if bee(i).cost < globest.cost
                globest = bee(i);
            end
        end
        
        bestcost(iter) = globest.cost;
        hold off;
        
        disp(['Iteration ' num2str(iter) ' | Minimum cost = ' num2str(bestcost(iter))] );
    end
    
    name = ['Beale pop=' num2str(npop)];
    video = VideoWriter(name,'MPEG-4');
    video.FrameRate = 24;
    open(video)
    writeVideo(video,frame);
    close(video)
    
    clf
    for iter = 1:itermax
        semilogy(1:iter,bestcost(1:iter));
        axis([1 itermax 1e-7 1 ]);
        title(['Minimum Value Plot | Population = ' num2str(npop) ' | MinVal = ' num2str(bestcost(iter))] );
        framec(iter) = getframe(gcf); pause(0.0001);        
    end
    
    name = ['Convergence Beale pop=' num2str(npop)];
    video = VideoWriter(name,'MPEG-4');
    video.FrameRate = 24;
    open(video)
    writeVideo(video,framec);
    close(video)
    
    bestbee = globest;
    mincost = bestcost;
end