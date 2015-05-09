function [dynamicWorld, collisionShapes, body, plotObj, data ] = createShape(type,dynamicWorld, collisionShapes,objOrigin, objDim, objAng, objMass, objProp) 
% General function for creating shapes both in matlab graphics-land and in
% Bullet physics-land. Right now, only supports types of sphere and box.
% TODO finish cylinder and add more shapes
%
% Matthew Sheen
import com.bulletphysics.collision.shapes.BoxShape;
import com.bulletphysics.collision.shapes.CylinderShape;
import com.bulletphysics.collision.shapes.CollisionShape;
import javax.vecmath.*;
import com.bulletphysics.linearmath.Transform;
import com.bulletphysics.linearmath.DefaultMotionState;
import com.bulletphysics.dynamics.RigidBodyConstructionInfo;
import com.bulletphysics.dynamics.RigidBody;
import com.bulletphysics.collision.shapes.SphereShape;

initialRot = angle2quat(objAng(1), objAng(2), objAng(3));

if strcmpi(type, 'box')
    %%Create a box:
    shape =  BoxShape(Vector3f(.5*objDim(1),.5*objDim(2),.5*objDim(3)));
    %Create plots
    [plotObj,data] = createPlotCube(objDim(1), objDim(2), objDim(3));
    plotShapeReposition(plotObj,data,initialRot,objOrigin);
else if strcmpi(type, 'sphere')
    shape =  SphereShape(0.5*objDim);
    %Create plots
    %    [plotObj,data] = createPlotCube(objDim, objDim, objDim);
    [plotObj,data] = createPlotSphere(objDim);
    plotShapeReposition(plotObj,data,initialRot,objOrigin);
    else if strcmpi(type, 'cylinder')
            
    shape =  CylinderShape(Vector3f(objDim(1),0,.5*objDim(2))); %RADIUS, height
    %Create plots
    %    [plotObj,data] = createPlotCube(objDim, objDim, objDim);
    [plotObj,data] = createPlotSphere(objDim(1)*2);
    plotShapeReposition(plotObj,data,initialRot,objOrigin);
    
        end
    end
end

localInertia =  Vector3f(0,0,0);
shape.calculateLocalInertia(objMass, localInertia);

collisionShapes.add(shape);
              
startTransform = Transform();
startTransform.setIdentity();
startTransform.origin.set(objOrigin(1), objOrigin(2), objOrigin(3));
        
rotation = Quat4f(initialRot);
startTransform.setRotation(rotation);    
        
ms =  DefaultMotionState(startTransform);
rbInfo =  RigidBodyConstructionInfo(objMass, ms, shape, localInertia);
body = RigidBody(rbInfo);

%Set properties:
body.setRestitution(objProp.restitution);
body.setFriction(objProp.friction);
body.setDamping(objProp.linDamp,objProp.angDamp);

data.localInertia = cell2mat(struct2cell(struct(localInertia)));

dynamicWorld.addRigidBody(body);

